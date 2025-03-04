//
//  TopAndBottomFadeoutOut.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 05/03/2025.
//

import SwiftUI

fileprivate struct TopAndBottomFadeOut: ViewModifier {
    var fadingColor: Color
    var gradientHeight: CGFloat
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                LinearGradient(
                    colors: [fadingColor, fadingColor.opacity(0)/* SwiftUI bug */],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: gradientHeight)
                
                Spacer()
                
                LinearGradient(
                    colors: [fadingColor.opacity(0)/* SwiftUI bug */, fadingColor],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: gradientHeight)
            }
        }
    }
}

extension View {
    
    func topAndBottomFadeOut(fadingColor: Color = .init(uiColor: .systemBackground), gradientHeight: CGFloat) -> some View {
        modifier(TopAndBottomFadeOut(fadingColor: fadingColor, gradientHeight: gradientHeight))
    }
}
