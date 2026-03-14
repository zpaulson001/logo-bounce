//
//  ContentView.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 3/5/26.
//

import SwiftUI

struct BottomBar: View {
    @Environment(MainToolbarSettings.self) private var mainToolbarSettings

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

            }

        }

    }
}

#Preview {
    ContentView()
}
