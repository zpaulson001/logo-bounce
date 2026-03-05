//
//  ContentView.swift
//  DVD
//
//  Created by Zac Paulson on 3/5/26.
//

import SwiftUI

struct BouncingLogo: View {
    // 1. State for position, velocity, and color
    @State private var pos = CGPoint(x: 100, y: 100)
    @State private var velocity = CGSize(width: 2, height: 2)
    @State private var logoColor: Color = .blue
    
    let logoWidth: CGFloat = 100
    let logoHeight: CGFloat = 50

    var body: some View {
        // 2. TimelineView creates a high-frequency animation loop
        TimelineView(.animation) { timeline in
            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    Color.black // Background
                    
                    // The "DVD" Logo
                    RoundedRectangle(cornerRadius: 10)
                        .fill(logoColor)
                        .frame(width: logoWidth, height: logoHeight)
                        .overlay(Text("DVD").foregroundColor(.black).bold())
                        .offset(x: pos.x, y: pos.y)
                }
                .onAppear {
                    // Center it initially
                    pos = CGPoint(x: geo.size.width/2, y: geo.size.height/2)
                }
                .onChange(of: timeline.date) { _, _ in
                    updatePosition(in: geo.size)
                }
            }
        }
        .ignoresSafeArea()
    }

    private func updatePosition(in size: CGSize) {
        var newX = pos.x + velocity.width
        var newY = pos.y + velocity.height

        // Bounce off Left/Right
        if newX <= 0 || newX + logoWidth >= size.width {
            velocity.width *= -1
            logoColor = Color(hue: Double.random(in: 0...1), saturation: 0.8, brightness: 1)
        }
        
        // Bounce off Top/Bottom
        if newY <= 0 || newY + logoHeight >= size.height {
            velocity.height *= -1
            logoColor = Color(hue: Double.random(in: 0...1), saturation: 0.8, brightness: 1)
        }

        pos = CGPoint(x: newX, y: newY)
    }
}

struct ContentView: View {
    var body = BouncingLogo()
}

#Preview {
    ContentView()
}
