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
    var isTimerInputFocused: Bool = false
    var timerInput: String = "00:00"
}

struct BottomBar: View {
    @Environment(MainToolbarSettings.self) private var mainToolbarSettings
    @Environment(TimerManager.self) private var timerManager

    @FocusState private var isTimerInputFocused

    func validateTimerInput() -> TimeInterval {

        let timesArray: [Int] = mainToolbarSettings.timerInput.split(
            separator: ":"
        )
        .map(String.init)
        .compactMap { substring in
            // 1. Trim the whitespace from the substring
            let trimmed = substring.trimmingCharacters(in: .whitespaces)

            // 2. Try to convert to Int.
            // If it fails (returns nil), compactMap skips it.
            return Int(trimmed)
        }

        if timesArray.isEmpty {
            return 0
        }

        if timesArray.count == 1 {
            return TimeInterval(timesArray[0] * 60)
        }

        var seconds = timesArray[timesArray.count - 1]
        seconds += timesArray[timesArray.count - 2] * 60
        return TimeInterval(seconds)
    }

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
                    if timerManager.timerStatus == .running {
                        Text(
                            Duration.seconds(
                                timerManager.timeRemaining
                            ).formatted(.time(pattern: .minuteSecond))
                        )
                        .fontDesign(.monospaced)
                        .foregroundColor(
                            Color(NSColor.disabledControlTextColor)
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        TextField(
                            "00:00:00",
                            text: $bindableSettings.timerInput,
                        )
                        .labelsHidden()
                        .fontDesign(.monospaced)
                        .focused($isTimerInputFocused)
                        .onAppear {
                            isTimerInputFocused = false
                        }
                        .onTapGesture {
                            isTimerInputFocused = true
                        }
                        .onChange(of: isTimerInputFocused) {
                            oldValue,
                            newValue in
                            if newValue == false {
                                timerManager.setTimer(
                                    duration: validateTimerInput()
                                )
                                bindableSettings.timerInput = Duration.seconds(
                                    timerManager.getTimerDuration()
                                ).formatted(.time(pattern: .minuteSecond))
                            }
                        }
                        .onSubmit {
                            timerManager.setTimer(
                                duration: validateTimerInput()
                            )
                            bindableSettings.timerInput = Duration.seconds(
                                timerManager.getTimerDuration()
                            ).formatted(.time(pattern: .minuteSecond))
                            isTimerInputFocused = false
                        }
                    }

                    Button {
                        timerManager.stop()
                    } label: {
                        Image(systemName: "square.fill")
                    }
                    .disabled(timerManager.timerStatus == .stopped)

                    Button {
                        switch timerManager.timerStatus {
                        case .running:
                            timerManager.pause()
                        case .paused:
                            timerManager.resume()
                        case .stopped:
                            timerManager.start()
                        }

                    } label: {
                        Image(
                            systemName: timerManager.timerStatus == .running
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
