//
//  BouncingLogoCanvas.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 3/17/26.
//

import SwiftUI

struct BouncingLogoCanvas: View {

    @State private var isResizing = false

    let speed: CGFloat = 300

    // The "Ping-Pong" function: Maps linear time to a bouncing coordinate
    private func calculateBounce(time: Double, speed: CGFloat, max: CGFloat)
        -> CGFloat
    {
        let totalDistance = time * Double(speed)
        let phase = totalDistance.truncatingRemainder(
            dividingBy: Double(max * 2)
        )
        return CGFloat(phase > Double(max) ? Double(max * 2) - phase : phase)
    }

    var body: some View {
        TimelineView(.animation(paused: isResizing)) { (timeline: TimelineViewDefaultContext) in

            Canvas { gc, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let logo = gc.resolve(
                    Image(
                        "jedediah_logo"
                    )
                )

                let logoSize = CGSize(
                    width: logo.size.width / 4,
                    height: logo.size.height / 4
                )

                let x = calculateBounce(
                    time: time,
                    speed: speed,
                    max: size.width - logoSize.width
                )
                let y = calculateBounce(
                    time: time,
                    speed: speed,
                    max: size.height - logoSize.height
                )

                let rect = CGRect(
                    origin: CGPoint(x: x, y: y),
                    size: logoSize
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
