//
//  DVDApp.swift
//  DVD
//
//  Created by Zac Paulson on 3/5/26.
//

import SwiftUI
import Observation


struct MainToolbar: ViewModifier {
    @State private var isShowingPopover = false
    @Environment(MainToolbarSettings.self) private var mainToolbarSettings

    func body(content: Content) -> some View {
        @Bindable var bindableSettings = mainToolbarSettings
        content
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button (action: {
                        isShowingPopover = true
                    }) {
                        Label("Settings", systemImage: "gearshape")
                    }
                    .popover(isPresented: $isShowingPopover, arrowEdge: .bottom) {
                        VStack {
                            Slider(
                                value: $bindableSettings.animationSpeed,
                                in: 1...10,
                                step: 2
                            )
                        }
                    }
                }
            }
            
        }
    
}

extension View {
    func mainToolbar() -> some View {
        modifier(MainToolbar())
    }
}
