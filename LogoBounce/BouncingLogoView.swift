//
//  BouncingLogoView.swift
//  Logo Bounce
//
//  Created by Zac Paulson on 3/17/26.
//

import SwiftUI

enum DVDPalette {
    // These use the .sRGB space to bypass macOS system "adaptations"
    static let white = Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
    static let red = Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 1)
    static let blue = Color(.sRGB, red: 0, green: 0, blue: 1, opacity: 1)
    static let green = Color(.sRGB, red: 0, green: 1, blue: 0, opacity: 1)
    static let yellow = Color(.sRGB, red: 1, green: 1, blue: 0, opacity: 1)
    static let cyan = Color(.sRGB, red: 0, green: 1, blue: 1, opacity: 1)
    static let magenta = Color(.sRGB, red: 1, green: 0, blue: 1, opacity: 1)
    
    static let all: [Color] = [blue, green, cyan, red, magenta, yellow]
}

class LogoPhysicsStore {
    
    var logoSize: CGSize = .zero
    var position: CGPoint = .init(x: 200, y: 200)
    var velocity: CGPoint = .init(x: 1, y: 1)  // Normalized direction
    var logoColor: Color = DVDPalette.white
    private var colorIndex: Int = 0

    private var lastDate: Date?
    
    private func nextColor() {
        colorIndex = (colorIndex + 1) % DVDPalette.all.count
        logoColor = DVDPalette.all[colorIndex]
    }

    func update(to currentDate: Date, within size: CGSize, baseSpeed: Double) {

        guard let lastDate = lastDate else {
            self.lastDate = currentDate
            return
        }

        let delta = currentDate.timeIntervalSince(lastDate)
        self.lastDate = currentDate

        if delta == 0 {
            return
        }

        var newX = position.x + velocity.x * baseSpeed * CGFloat(delta)
        var newY = position.y + velocity.y * baseSpeed * CGFloat(delta)

        // bounce off left/right
        if newX <= 0 || newX + logoSize.width >= size.width {
            velocity.x *= -1
            nextColor()
        }

        if newX < 0 {
            newX = 0.0
        }

        if newX + logoSize.width > size.width {
            newX = size.width - logoSize.width
        }

        //bounce off top/bottom
        if newY <= 0 || newY + logoSize.height >= size.height {
            velocity.y *= -1
            nextColor()
        }

        if newY < 0 {
            newY = 0.0
        }

        if newY + logoSize.height > size.height {
            newY = size.height - logoSize.height
        }

        position.x = newX
        position.y = newY

    }
}

struct BouncingLogoView: View {

    @State private var logoPhysicsStore: LogoPhysicsStore = .init()
    @Environment(MainToolbarSettings.self) private var toolbarSettings

    var body: some View {
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

    }
}

#Preview {
    BouncingLogoView()
}
