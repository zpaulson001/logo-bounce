//
//  ContentView.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 3/5/26.
//

import SwiftUI

struct BottomBar: View {
    @Environment(MainToolbarSettings.self) private var mainToolbarSettings

    let logoNames = ["jedediah_logo", "pbc_logo"]

    var body: some View {
        @Bindable var bindableSettings = mainToolbarSettings

        VStack {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {

                ZStack {
                    Slider(
                        value: $bindableSettings.animationSpeed,
                        in: 1...10,
                        step: 1,
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
                .background(.ultraThinMaterial)
                .clipShape(Capsule())

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
                .background(.ultraThinMaterial)
                .clipShape(Capsule())

                ZStack {
                    Picker(
                        "Select Logo Name",
                        selection: $bindableSettings.logoName
                    ) {
                        Text("Jedediah").tag("jedediah_logo")
                        Text("PBC").tag("pbc_logo")
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .padding()
                }
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
            }

        }

    }

}

#Preview {
    ContentView()
}
