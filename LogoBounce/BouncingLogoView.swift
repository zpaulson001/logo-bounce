//
//  BouncingLogoView.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 3/17/26.
//

import SwiftUI

struct BouncingLogoView: View {

    @State private var logoPhysicsStore: LogoPhysicsStore = .init()
    @Environment(MainToolbarSettings.self) private var toolbarSettings
    @Environment(TimerManager.self) private var timerManager

    var body: some View {
        ZStack {
            TimelineView(.animation) { (timeline: TimelineViewDefaultContext) in
                GeometryReader { container_geo in
                    Image(toolbarSettings.selectedLogo)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(height: toolbarSettings.desiredLogoHeight)
                        .foregroundStyle(logoPhysicsStore.logoColor)
                        .offset(
                            x: logoPhysicsStore.position.x,
                            y: logoPhysicsStore.position.y
                        )
                        .onGeometryChange(for: CGSize.self) {
                            proxy in
                            proxy.size
                        } action: { newSize in
                            logoPhysicsStore.logoSize.height =
                                newSize.height
                            logoPhysicsStore.logoSize.width =
                                newSize.width
                        }
                        .onChange(of: timeline.date) { _, _ in
                            logoPhysicsStore.update(
                                to: timeline.date,
                                within: container_geo.size,
                                baseSpeed: toolbarSettings.animationSpeed
                            )
                        }
                }
            }
            .background(.black)
            .ignoresSafeArea()

            if timerManager.timerStatus != .stopped {
                Text(
                    Duration.seconds(
                        timerManager.timeRemaining
                    ).formatted(.time(pattern: .minuteSecond))
                )
                .fontDesign(.monospaced)
                .font(.system(size: 200, weight: .bold))
                .foregroundColor(Color.white)
            }

        }

    }

}

#Preview {
    BouncingLogoView()
}
