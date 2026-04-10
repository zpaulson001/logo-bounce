//
//  ImageStore.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 4/8/26.
//

import SwiftUI

extension NSImage {
    static func blankImage(size: NSSize, color: NSColor = .blue) -> NSImage {
        return NSImage(size: size, flipped: false) { rect in
            color.set()
            rect.fill()
            return true  // Confirms the drawing was successful
        }
    }
}

@Observable
class ImageStore {
    // Persistent list of filenames

    var filenames: [String] = []

    private var savedFilesData: Data =
        UserDefaults.standard.data(forKey: "savedFiles") ?? Data()
    {
        didSet {
            UserDefaults.standard.set(savedFilesData, forKey: "savedFiles")
        }
    }

    private let fileManager = FileManager.default
    private let imageDirectoryName = "Images"
    private var imageCache: [String: NSImage] = [:]

    // 1. Centralized URL property
    private var appFolderURL: URL {
        let paths = fileManager.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )
        let bundleID = Bundle.main.bundleIdentifier ?? "com.default.app"
        return paths[0].appendingPathComponent(bundleID).appendingPathComponent(
            imageDirectoryName
        )
    }

    private var defaultImage =
        NSImage(
            systemSymbolName: "photo",
            accessibilityDescription: "Placeholder"
        ) ?? NSImage.blankImage(size: NSSize(width: 100, height: 100))

    init() {
        ensureFolderExists()
        refreshFileList()
    }

    private func ensureFolderExists() {
        try? fileManager.createDirectory(
            at: appFolderURL,
            withIntermediateDirectories: true
        )
    }

    // 2. The Sync Logic
    func refreshFileList() {
        do {

            let keys: [URLResourceKey] = [.addedToDirectoryDateKey]
            let urls = try fileManager.contentsOfDirectory(
                at: appFolderURL,
                includingPropertiesForKeys: keys,
                options: .skipsHiddenFiles
            )

            let sortedURLs = urls.sorted { (url1, url2) -> Bool in
                let date1 = (try? url1.resourceValues(forKeys: [.addedToDirectoryDateKey]))?.addedToDirectoryDate
                            let date2 = (try? url2.resourceValues(forKeys: [.addedToDirectoryDateKey]))?.addedToDirectoryDate

                // Sort descending (newest first). Use < for oldest first.
                return (date1 ?? Date.distantPast) < (date2 ?? Date.distantPast)
            }

            let names = sortedURLs.filter { !$0.hasDirectoryPath }.map {
                $0.lastPathComponent
            }

            if let encoded = try? JSONEncoder().encode(names) {
                savedFilesData = encoded
                filenames = names
            }
        } catch {
            print("Sync Error: \(error)")
        }
    }

    func saveFile(originalURL: URL) {
        // 1. Gain Sandbox Permission
        guard originalURL.startAccessingSecurityScopedResource() else {
            return
        }
        defer { originalURL.stopAccessingSecurityScopedResource() }

        let fileName = originalURL.lastPathComponent
        let destinationURL = appFolderURL.appendingPathComponent(fileName)

        // 3. Copy it
        do {
            try fileManager.copyItem(at: originalURL, to: destinationURL)
            refreshFileList()
            print(destinationURL)
        } catch {
            print("Copy failed: \(error)")
            return
        }
    }

    func getFile(named name: String) -> NSImage {
        // 1. Return from memory if already loaded
        if let cached = imageCache[name] {
            return cached
        }

        let url = appFolderURL.appendingPathComponent(name)

        if let loadedImage = NSImage(contentsOf: url) {
            // 3. Store in dictionary for next time
            imageCache[name] = loadedImage
            return loadedImage
        }

        return defaultImage
    }

    // 3. The "Atomic" Delete
    func deleteFile(named name: String) {
        let url = appFolderURL.appendingPathComponent(name)

        do {
            // Remove from Disk
            try fileManager.removeItem(at: url)

            imageCache.removeValue(forKey: name)
            // Remove from Storage immediately after successful disk deletion
            refreshFileList()
        } catch {
            print("Delete failed: \(error)")
        }

    }
}
