//
//  XCircleFill.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 05/03/2025.
//

import SwiftUI

struct XCircleFill: View {
    
    @State private var leftCapsuleTrim = 1.0
    @State private var rightCapsuleTrim = 1.0

    private let lineWidthRatio = 0.6
    private let lineThicknessRatio = 0.095
    private let animationDuration = 0.2
    
    var circleFillColor: Color = .indigo
    var xColor: Color = .white
    var animated = true
    var animationDelay = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .foregroundStyle(circleFillColor)
                .overlay {
                    ZStack {
                        capsuledLine(in: geometry, xOffset: leftCapsuleTrim)
                            .rotationEffect(.degrees(45))
                        
                        capsuledLine(in: geometry, xOffset: rightCapsuleTrim)
                            .rotationEffect(.degrees(-45))
                    }
                }
                .onAppear {
                    guard animated else { return }
                    leftCapsuleTrim = -geometry.size.width * lineWidthRatio
                    rightCapsuleTrim = geometry.size.width * lineWidthRatio
                    
                    withAnimation(.easeIn(duration: animationDuration).delay(animationDelay)) {
                        leftCapsuleTrim = 0
                    }
                    
                    withAnimation(.easeIn(duration: animationDuration).delay(animationDelay + animationDuration / 2)) {
                        rightCapsuleTrim = 0
                    }
                }
        }
    }
    
    private func capsuledLine(in geometry: GeometryProxy, xOffset: CGFloat) -> some View {
        Capsule()
            .fill(xColor)
            .frame(width: geometry.size.width * lineWidthRatio, height: geometry.size.width * lineThicknessRatio)
            .offset(x: xOffset, y: 0)
            .clipShape(Capsule())
    }
}

#Preview {
    XCircleFill()
}
