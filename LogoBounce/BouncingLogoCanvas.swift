//
//  BouncingLogoCanvas.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 3/17/26.
//

import SwiftUI

struct BouncingLogoCanvas: View {

    @State private var isResizing = false
    @State private var logoPhysicsStore: LogoPhysicsStore = .init()
    @Environment(MainToolbarSettings.self) private var toolbarSettings

    var body: some View {
        TimelineView(.animation(paused: isResizing)) {
            (timeline: TimelineViewDefaultContext) in

            Canvas { gc, size in
                var logo = gc.resolve(
                    Image(
                        toolbarSettings.selectedCustomLogo
                    )
                )

                let desiredLogoWidth =
                    logo.size.width
                    / (logo.size.height / toolbarSettings.desiredLogoHeight)

                logoPhysicsStore.logoSize.width = desiredLogoWidth
                logoPhysicsStore.logoSize.height =
                    toolbarSettings.desiredLogoHeight

                logoPhysicsStore.update(
                    to: timeline.date,
                    within: size,
                    baseSpeed: toolbarSettings.animationSpeed
                )
                logo.shading = .color(logoPhysicsStore.logoColor)

                let rect = CGRect(
                    origin: CGPoint(
                        x: logoPhysicsStore.position.x,
                        y: logoPhysicsStore.position.y
                    ),
                    size: CGSize(
                        width: desiredLogoWidth,
                        height: toolbarSettings.desiredLogoHeight
                    )
                )

                gc.draw(
                    logo,
                    in: rect,
                )
            }
        }
//        .onReceive(
//            NotificationCenter.default.publisher(
//                for: NSWindow.willStartLiveResizeNotification
//            )
//        ) { _ in
//            isResizing = true
//        }
//        .onReceive(
//            NotificationCenter.default.publisher(
//                for: NSWindow.didEndLiveResizeNotification
//            )
//        ) { _ in
//            isResizing = false
//        }
        .background(.black)
        .border(.red, width: 1)
        .ignoresSafeArea()

    }
}
