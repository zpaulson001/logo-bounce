//
//  ContentView.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 3/5/26.
//

import SwiftUI

@Observable
class MainToolbarSettings {
    var animationSpeed: Double = 0.4
    var desiredLogoHeight: Double = 300
    var isVisible: Bool = true
    var isImporting: Bool = false
    var colorMode: ColorMode = .overlay
    var logoType: LogoType = .pbc
    var selectedPBCLogo: PBCLogo = .jedediah
    var selectedCustomLogo = ""
    var timerInput: String = "00:00"
    var isLogoManageMode: Bool = false
    var selectedImages: Set<String> = []

    private var maxScaledSpeed: Double = 5000
    private var minScaledSpeed: Double = 50

    var scaledSpeed: Double {
        let range = maxScaledSpeed - minScaledSpeed
        return pow(animationSpeed, 4) * range + minScaledSpeed
    }
}

struct BottomBar: View {
    @Environment(MainToolbarSettings.self) private var mainToolbarSettings
    @Environment(WindowManagementStore.self) private var windowManagementStore
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
                    in: 0...1,
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

                ColorModeSelector()

                LogoTypePicker()

                switch bindableSettings.logoType {
                case .pbc:
                    PBCLogoPicker()
                case .custom:
                    if mainToolbarSettings.isLogoManageMode {
                        ImageManager()
                    } else {
                        ImageSelector(
                            selection: $bindableSettings.selectedCustomLogo
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
