//
//  FilePicker.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 4/4/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct FilePicker: View {
    @Environment(MainToolbarSettings.self) private var mainToolbarSettings
    @Environment(ImageStore.self) private var imageStore


    var body: some View {
        @Bindable var bindableSettings = mainToolbarSettings
        
        Button(action: {
            print("importing logo")
            mainToolbarSettings.isImporting = true
        }) {
            Image(systemName: "plus")
        }
        .fileImporter(
            isPresented: $bindableSettings.isImporting,
            allowedContentTypes: [.image],
        ) { result in
            switch result {
            case .success(let url):
                print("Selected: \(url.path)")
                imageStore.saveFile(originalURL: url)
                print(imageStore.filenames)
            case .failure(let error):
                print(
                    "Error selecting file: \(error.localizedDescription)"
                )
            }
        }
    }
}

#Preview {
    FilePicker()
}
