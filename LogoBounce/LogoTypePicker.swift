//
//  SwiftUIView.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 4/4/26.
//

import SwiftUI

enum LogoType: String, CaseIterable, Identifiable {
    case pbc = "PBC"
    case custom = "Custom"

    // Identifiable requirement
    var id: Self { self }

}

struct LogoTypePicker: View {
    @Environment(MainToolbarSettings.self) private var mainToolbarSettings

    var body: some View {
        @Bindable var bindableSettings = mainToolbarSettings

        Picker("Logo Type", selection: $bindableSettings.logoType) {
            ForEach(LogoType.allCases) { logoType in
                Text(logoType.rawValue).tag(logoType)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    LogoTypePicker()
}
