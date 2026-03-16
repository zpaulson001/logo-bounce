//
//  ContentView.swift
//  LogoBounce
//
//  Created by Zac Paulson on 3/5/26.
//

import SwiftUI

struct BouncingLogo: View {
    // 1. State for position, velocity, and color

    @Environment(MainToolbarSettings.self) private var toolbarSettings

    @State private var pos = CGPoint(x: 100, y: 100)
    @State private var velocity = CGSize(width: 1, height: 1)
    @State private var colorIndex: Int = 0
    @State private var logoColor: Color = Color.white
    @State private var logoWidth: CGFloat = 0
    @State private var logoHeight: CGFloat = 0

    let logoColors = [
        Color.white, Color.yellow, Color.cyan, Color.green,
        Color(red: 1, green: 0, blue: 1), Color.red, Color.blue,
    ]

    var body: some View {
        // 2. TimelineView creates a high-frequency animation loop
        TimelineView(.animation) { timeline in
            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    Color.black  // Background

                    Image("jedediah_logo")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(height: toolbarSettings.desiredLogoHeight)
                        .foregroundStyle(logoColor)
                        .offset(x: pos.x, y: pos.y)
                        .background(
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        logoHeight = geometry.size.height
                                        logoWidth = geometry.size.width
                                    }
                                    .onGeometryChange(for: CGSize.self) { proxy in
                                        proxy.size
                                    } action: {newSize in
                                        logoHeight = geometry.size.height
                                        logoWidth = geometry.size.width
                                    }
                            }
                        )
                    if toolbarSettings.isVisible {
                        BottomBar()
                            .padding()
                            .transition(.opacity)
                            .zIndex(1)
                    }

                }
                .onAppear {
                    // Center it initially
                    pos = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                .onChange(of: timeline.date) { _, _ in
                    updatePosition(
                        in: geo.size,
                        animationSpeed: toolbarSettings.animationSpeed
                    )
                }
            }
        }
        .ignoresSafeArea()

    }

    private func updatePosition(in size: CGSize, animationSpeed: CGFloat = 1) {
        let newX = pos.x + velocity.width * animationSpeed
        let newY = pos.y + velocity.height * animationSpeed

        // Bounce off Left/Right
        if newX <= 0 || newX + logoWidth >= size.width {
            velocity.width *= -1
            logoColor = Color(
                hue: Double.random(in: 0...1),
                saturation: 0.8,
                brightness: 1
            )
            //            nextColor()
        }

        // Bounce off Top/Bottom
        if newY <= 0 || newY + logoHeight >= size.height {
            velocity.height *= -1
            logoColor = Color(
                hue: Double.random(in: 0...1),
                saturation: 0.8,
                brightness: 1
            )
            //            next color()
        }

        pos = CGPoint(x: newX, y: newY)
    }

    private func nextColor() {
        colorIndex = (colorIndex + 1) % logoColors.count
    }
}

struct ContentView: View {
    var body = BouncingLogo()
}

#Preview {
    ContentView()
}
