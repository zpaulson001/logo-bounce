//
//  WindowManagementStore.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 4/9/26.
//

import SwiftUI

@Observable
class WindowManagementStore {
    var hideWorkItem: DispatchWorkItem?
    var mouseInWindow: Bool = false
    var mouseInToolbar: Bool = false
    
    func updateWindowAppearance(visible: Bool) {
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
