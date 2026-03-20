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

        BouncingLogoView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .trailing) {
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
