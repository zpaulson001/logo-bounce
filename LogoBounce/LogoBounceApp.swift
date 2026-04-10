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
    @State private var imageStore = ImageStore()
    @State private var windowManagementStore = WindowManagementStore()
    @AppStorage("file_names") var fileNames: String = ""

    var body: some Scene {
        WindowGroup {
            ContentView()
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .navigationTitle("")
                .environment(mainToolbarSettings)
                .environment(timerManager)
                .environment(imageStore)
                .environment(windowManagementStore)
                .onAppear {
                    let workItem = DispatchWorkItem {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            mainToolbarSettings.isVisible = false
                        }
                        windowManagementStore.updateWindowAppearance(
                            visible: false
                        )
                        NSCursor.hide()
                    }
                    windowManagementStore.hideWorkItem = workItem
                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + 2.5,
                        execute: workItem
                    )
                }
                .onContinuousHover { phase in
                    switch phase {
                    case .active:

                        windowManagementStore.mouseInWindow = true

                        if !mainToolbarSettings.isVisible {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                mainToolbarSettings.isVisible = true
                            }
                            windowManagementStore.updateWindowAppearance(
                                visible: true
                            )
                            NSCursor.unhide()
                        }

                        // 2. Cancel the previous "hide" timer
                        windowManagementStore.hideWorkItem?.cancel()

                        if windowManagementStore.mouseInToolbar
                            || mainToolbarSettings.isImporting
                        {
                            break
                        }

                        // 3. Start a new 2-second timer
                        let workItem = DispatchWorkItem {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                mainToolbarSettings.isVisible = false
                            }
                            windowManagementStore.updateWindowAppearance(
                                visible: false
                            )
                            if windowManagementStore.mouseInWindow {
                                NSCursor.hide()
                            }
                        }
                        windowManagementStore.hideWorkItem = workItem
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + 2.5,
                            execute: workItem
                        )
                    case .ended:
                        windowManagementStore.mouseInWindow = false
                        NSCursor.unhide()
                    }
                }
                .onDisappear {
                    NSCursor.unhide()
                }

        }
    }

}
