//
//  DVDApp.swift
//  LogoBounce
//
//  Created by Zac Paulson on 3/5/26.
//

import Observation
import SwiftUI

@Observable
class MainToolbarSettings {
    var animationSpeed: Double = 1
    var desiredLogoHeight: Double = 200
    var isVisible: Bool = true
}

@main
struct LogoBounceApp: App {
    @State private var mainToolbarSettings = MainToolbarSettings()
    @State private var hideWorkItem: DispatchWorkItem?

    var body: some Scene {
        WindowGroup {
            ContentView()
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .navigationTitle("")
                .environment(mainToolbarSettings)
                .onAppear {
                    let workItem = DispatchWorkItem {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            mainToolbarSettings.isVisible = false
                        }
                        updateWindowAppearance(visible: false)
                        NSCursor.hide()
                    }
                    hideWorkItem = workItem
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 2.5,
                        execute: workItem
                    )
                }
                .onContinuousHover { phase in
                    switch phase {
                    case .active:

                        if !mainToolbarSettings.isVisible {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                mainToolbarSettings.isVisible = true
                            }
                            updateWindowAppearance(visible: true)
                            NSCursor.unhide()
                        }

                        // 2. Cancel the previous "hide" timer
                        hideWorkItem?.cancel()

                        // 3. Start a new 2-second timer
                        let workItem = DispatchWorkItem {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                mainToolbarSettings.isVisible = false
                            }
                            updateWindowAppearance(visible: false)
                            NSCursor.hide()
                        }
                        hideWorkItem = workItem
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 2.5,
                            execute: workItem
                        )
                    case .ended:
                        break
                    }
                }

        }
    }

    private func updateWindowAppearance(visible: Bool) {
        // Find the underlying NSWindow
        guard let window = NSApp.keyWindow ?? NSApp.windows.first else {
            return
        }

        // 2. Handle the "Traffic Lights" (Close, Minimize, Zoom)
        let buttons: [NSWindow.ButtonType] = [
            .closeButton, .miniaturizeButton, .zoomButton,
        ]
        for buttonType in buttons {
            if let button = window.standardWindowButton(buttonType) {
                // Using animator() gives it that smooth QuickTime fade
                button.animator().alphaValue = visible ? 1.0 : 0.0
            }
        }
    }
}
