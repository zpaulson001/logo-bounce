//
//  DVDApp.swift
//  DVD
//
//  Created by Zac Paulson on 3/5/26.
//

import SwiftUI
import Observation

@Observable
class MainToolbarSettings {
    var animationSpeed: Double = 1
}

@Observable
class MouseLocation {
    var x: CGFloat = 0
    var y: CGFloat = 0
}

@main
struct DVDApp: App {
    @State private var mainToolbarSettings = MainToolbarSettings()
    @State private var mouseLocation = MouseLocation()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .navigationTitle("")
                .environment(mainToolbarSettings)
                .environment(mouseLocation)
                .onContinuousHover { phase in
                    switch phase {
                    case .active(let location):
                        mouseLocation.x = location.x
                        mouseLocation.y = location.y
                    case .ended:
                        break
                    }
                }
            
        }
    }
}

