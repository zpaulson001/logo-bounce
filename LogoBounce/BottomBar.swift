//
//  ContentView.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 3/5/26.
//

import SwiftUI

@Observable
class MainToolbarSettings {
    var animationSpeed: Double = 200
    var desiredLogoHeight: Double = 300
    var isVisible: Bool = true
    var selectedLogo = "jedediah_logo"
    var mouseInWindow: Bool = false
    var mouseInToolbar: Bool = false
    var isTimerRunning: Bool = false
    var isTimerInputFocused: Bool = false
    var timerInput: String = "0"

    func timerToggle() {
        isTimerRunning = !isTimerRunning
    }
}

struct BottomBar: View {
    @Environment(MainToolbarSettings.self) private var mainToolbarSettings

    let selectedLogos = ["jedediah_logo", "pbc_logo", "678_logo"]

    var body: some View {
        @Bindable var bindableSettings = mainToolbarSettings

        VStack {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {

                ZStack {
                    Slider(
                        value: $bindableSettings.animationSpeed,
                        in: 50...2000,
                        label: {
                            Text("Speed")
                        },
                        minimumValueLabel: {
                            Image(systemName: "tortoise")
                        },
                        maximumValueLabel: {
                            Image(systemName: "hare")
                        }

                    )
                    .labelsHidden()
                    .frame(maxWidth: 200)
                    .padding()
                }

                ZStack {
                    Slider(
                        value: $bindableSettings.desiredLogoHeight,
                        in: 40...500,
                        label: {
                            Text("Speed")
                        },
                        minimumValueLabel: {
                            Image(systemName: "textformat.size.smaller")
                        },
                        maximumValueLabel: {
                            Image(systemName: "textformat.size.larger")
                        }

                    )
                    .labelsHidden()
                    .frame(maxWidth: 200)
                    .padding()
                }

                ZStack {
                    Picker(
                        "Select Logo Name",
                        selection: $bindableSettings.selectedLogo
                    ) {
                        Text("678").tag("678_logo")
                        Text("Jedediah").tag("jedediah_logo")
                        Text("PBC (Circle)").tag("pbc_logo")
                        Text("PBC (Full)").tag("pbc_logo_full")
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .padding()
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(Capsule())

        }

    }

}

#Preview {
    ContentView()
}
