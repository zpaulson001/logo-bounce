//
//  SwiftUIView.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 4/6/26.
//

import SwiftUI

enum ColorMode: String, CaseIterable, Identifiable {
    case overlay = "Overlay"
    case tine = "Tint"

    // Identifiable requirement
    var id: Self { self }

}

struct ColorModeSelector: View {
    @Environment(MainToolbarSettings.self) private var mainToolbarSettings

    var body: some View {
        @Bindable var bindableSettings = mainToolbarSettings

        Picker("Color Mode", selection: $bindableSettings.colorMode) {
            ForEach(ColorMode.allCases) { colorMode in
                Text(colorMode.rawValue).tag(colorMode)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    ColorModeSelector()
}
