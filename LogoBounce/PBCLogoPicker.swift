//
//  SwiftUIView.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 4/4/26.
//

import SwiftUI

enum PBCLogo: String, CaseIterable, Identifiable {
    case jedediah = "Jedediah"
    case _678 = "678"
    case pbc = "PBC"
    case pbcFull = "PBC (Full)"

    var id: Self { self }

    // This acts like your dictionary "value"
    var name: String {
        switch self {
        case .jedediah: return "jedediah_logo"
        case ._678: return "678_logo"
        case .pbc: return "pbc_logo"
        case .pbcFull: return "pbc_logo_full"
        }
    }
}

struct PBCLogoPicker: View {
    @Environment(MainToolbarSettings.self) private var mainToolbarSettings

    var body: some View {
        @Bindable var bindableSettings = mainToolbarSettings

        Picker("Logo", selection: $bindableSettings.selectedPBCLogo) {
            ForEach(PBCLogo.allCases) { pbcLogo in
                Text(pbcLogo.rawValue).tag(pbcLogo)
            }
        }
    }
}

#Preview {
    LogoTypePicker()
}
