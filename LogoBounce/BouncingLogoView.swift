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
    @Environment(WindowManagementStore.self) private var windowManagementStore

    @Environment(TimerManager.self) private var timerManager
    @Environment(ImageStore.self) var imageStore

    var body: some View {
        ZStack {

            TimelineView(.animation) { (timeline: TimelineViewDefaultContext) in
                GeometryReader { container_geo in

                    switch toolbarSettings.logoType {
                    case .pbc:
                        Image(toolbarSettings.selectedPBCLogo.name)
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
                                    baseSpeed: toolbarSettings.scaledSpeed
                                )
                            }
                    case .custom:
                        if toolbarSettings.colorMode == .overlay {
                            Image(
                                nsImage: imageStore.getFile(
                                    named: toolbarSettings.selectedCustomLogo
                                )
                            )
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
                                    baseSpeed: toolbarSettings.scaledSpeed
                                )
                            }
                        } else {
                            Image(
                                nsImage: imageStore.getFile(
                                    named: toolbarSettings.selectedCustomLogo
                                )
                            )
                            .resizable()
                            .scaledToFit()
                            .frame(height: toolbarSettings.desiredLogoHeight)
                            .colorMultiply(logoPhysicsStore.logoColor)
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
                                    baseSpeed: toolbarSettings.scaledSpeed
                                )
                            }
                        }

                    }

                }
            }

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
        .background(.black)
        .ignoresSafeArea()
        .onTapGesture {
            if toolbarSettings.isVisible {
                windowManagementStore.hideWorkItem?.cancel()
                withAnimation(.easeInOut(duration: 0.2)) {
                    toolbarSettings.isVisible = false
                }
                windowManagementStore.updateWindowAppearance(
                    visible: false
                )
                NSCursor.hide()
            }
        }

    }

}

#Preview {
    BouncingLogoView()
}
