//
//  DVDApp.swift
//  LogoBounce
//
//  Created by Zac Paulson on 3/5/26.
//

import SwiftUI

@main
struct LogoBounceApp: App {
    @State private var mainToolbarSettings = MainToolbarSettings()
    @State private var timerManager = TimerManager()
    @State private var hideWorkItem: DispatchWorkItem?

    var body: some Scene {
        WindowGroup {
            ContentView()
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .navigationTitle("")
                .environment(mainToolbarSettings)
                .environment(timerManager)
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

                        mainToolbarSettings.mouseInWindow = true

                        if !mainToolbarSettings.isVisible {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                mainToolbarSettings.isVisible = true
                            }
                            updateWindowAppearance(visible: true)
                            NSCursor.unhide()
                        }

                        // 2. Cancel the previous "hide" timer
                        hideWorkItem?.cancel()

                        if mainToolbarSettings.mouseInToolbar {
                            break
                        }

                        // 3. Start a new 2-second timer
                        let workItem = DispatchWorkItem {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                mainToolbarSettings.isVisible = false
                            }
                            updateWindowAppearance(visible: false)
                            if mainToolbarSettings.mouseInWindow {
                                NSCursor.hide()
                            }
                        }
                        hideWorkItem = workItem
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 2.5,
                            execute: workItem
                        )
                    case .ended:
                        mainToolbarSettings.mouseInWindow = false
                        NSCursor.unhide()
                    }
                }
                .onTapGesture {
                    if mainToolbarSettings.isVisible {
                        hideWorkItem?.cancel()
                        mainToolbarSettings.isTimerInputFocused = false
                        withAnimation(.easeInOut(duration: 0.2)) {
                            mainToolbarSettings.isVisible = false
                        }
                        updateWindowAppearance(visible: false)
                        NSCursor.hide()
                    }
                }
                .onDisappear {
                    NSCursor.unhide()
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
