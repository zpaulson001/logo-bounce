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
    @FocusState private var isTimerInputFocused

    let selectedLogos = ["jedediah_logo", "pbc_logo", "678_logo", "ge_logo"]

    var body: some View {
        @Bindable var bindableSettings = mainToolbarSettings

        Form {
            Section("Animation Settings") {
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

                Slider(
                    value: $bindableSettings.desiredLogoHeight,
                    in: 40...500,
                    label: {
                        Text("Size")
                    },
                    minimumValueLabel: {
                        Image(systemName: "textformat.size.smaller")
                    },
                    maximumValueLabel: {
                        Image(systemName: "textformat.size.larger")
                    }

                )

                Picker(
                    "Logo",
                    selection: $bindableSettings.selectedLogo
                ) {
                    Text("DVD").tag("DVD_logo")
                    Text("678").tag("678_logo")
                    Text("Jedediah").tag("jedediah_logo")
                    Text("PBC (Circle)").tag("pbc_logo")
                    Text("PBC (Full)").tag("pbc_logo_full")
                    Text("GE").tag("ge_logo")
                    Text("Gloria Dei").tag("gloria_dei_logo")
                }
            }

            Section("Timer") {

                HStack {
                    TextField("00:00:00", text: $bindableSettings.timerInput)
                        .labelsHidden()
                        .focused($isTimerInputFocused)
                        .disabled(bindableSettings.isTimerRunning)
                        .onAppear {
                            isTimerInputFocused = false
                        }
                        .onTapGesture {
                            isTimerInputFocused = true
                        }
                        .onChange(of: isTimerInputFocused) { oldValue, newValue in
                            if newValue == false {
                                bindableSettings.timerInput = "1000"
                            }
                        }

                    Button {
                        return
                    } label: {
                        Image(systemName: "backward.end.fill")
                    }

                    Button {
                        bindableSettings.timerToggle()
                    } label: {
                        Image(
                            systemName: bindableSettings.isTimerRunning
                                ? "pause.fill" : "play.fill"
                        )
                    }
                }
                .frame(maxWidth: .infinity)

            }

        }
        .formStyle(.grouped)
        .frame(maxWidth: 300)
        .background(.ultraThinMaterial)
        .onTapGesture {
            isTimerInputFocused = false
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onHover { hovering in
            mainToolbarSettings.mouseInToolbar = hovering
        }

    }

}

#Preview {
    ContentView()
}
