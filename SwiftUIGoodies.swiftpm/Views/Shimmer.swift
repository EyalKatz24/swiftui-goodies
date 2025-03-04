//
//  Shimmer.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 05/03/2025.
//

import SwiftUI

struct Shimmer<S: Shape>: View {
    @State private var animating = false
    var shape: S
    var foregroundColor: Color = .secondary.opacity(0.2)
    var shimmerColor: Color = .white.opacity(0.5)
    
    var body: some View {
        GeometryReader { geometry in
            shape
                .foregroundColor(foregroundColor)
                .overlay(
                    LinearGradient(
                        colors: [
                            .clear,
                            shimmerColor,
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.7)
                    .offset(x: geometry.size.width * (animating ? 1.4 : -1.4))
                    .animation(
                        .linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                        value: animating
                    )
                )
                .clipShape(shape)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        animating = true
                    }
                }
        }
    }
}

#Preview {
    Shimmer(shape: .capsule)
        .frame(width: 150, height: 20)
}
