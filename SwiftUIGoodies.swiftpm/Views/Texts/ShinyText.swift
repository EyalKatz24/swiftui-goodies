//
//  ShinyText.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 05/03/2025.
//


import SwiftUI

struct ShinyText: View {
    
    @Environment(\.layoutDirection) private var layoutDirection
    @State private var xOffset: CGFloat = .zero
    let text: String
    let foregroundColor: Color
    let shimmerColor: Color
    let animationDuration: TimeInterval
    let delay: TimeInterval
    
    init(_ text: String, foregroundColor: Color = .app(.shinyTextForeground), shimmerColor: Color = .white.opacity(0.9), animationDuration: TimeInterval = 1.0, delay: TimeInterval = 2.5) {
        self.text = text
        self.foregroundColor = foregroundColor
        self.shimmerColor = shimmerColor
        self.animationDuration = animationDuration
        self.delay = delay
    }
    
    var body: some View {
        ZStack {
            Text(text)
                .foregroundStyle(foregroundColor)
            
            Text(text)
                .foregroundStyle(shimmerColor)
                .accessibilityHidden(true)
                .mask {
                    GeometryReader{ geometry in
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0.25),
                                .init(color: shimmerColor, location: 0.5),
                                .init(color: .clear, location: 0.75)
                            ],
                            startPoint: layoutDirection == .rightToLeft ? .topLeading : .bottomLeading,
                            endPoint: layoutDirection == .rightToLeft ? .bottomTrailing : .topTrailing
                        )
                        .offset(x: xOffset, y: .zero)
                        .onAppear { startAnimation(with: geometry) }
                    }
                }
        }
    }
    
    private func startAnimation(with geometry: GeometryProxy) {
        let directionFactor: CGFloat = layoutDirection == .leftToRight ? 1 : -1
        let xCoordinate = geometry.size.width * directionFactor
        xOffset = -xCoordinate
        
        withAnimation(.linear(duration: animationDuration).delay(delay).repeatForever(autoreverses: false)) {
            xOffset = xCoordinate
        }
    }
}

#Preview {
    ShinyText("Created by Eyal Katz")
        .font(.system(.headline, weight: .black))
}
