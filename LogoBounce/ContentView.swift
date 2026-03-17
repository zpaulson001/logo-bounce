//
//  ContentView.swift
//  LogoBounce
//
//  Created by Zac Paulson on 3/5/26.
//

import SwiftUI

struct ContentView: View {
    @Environment(MainToolbarSettings.self) private var toolbarSettings

    var body: some View {
        ZStack {
            BouncingLogoView()
            if toolbarSettings.isVisible {
                BottomBar()
                    .padding()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    ContentView()
}
