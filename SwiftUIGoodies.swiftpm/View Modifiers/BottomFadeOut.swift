//
//  BottomFadeOut.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 05/03/2025.
//

import SwiftUI

fileprivate struct BottomFadeOut: ViewModifier {
    let backgroundColor: Color
    let height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay {
                VStack {
                    Spacer()
                    
                    LinearGradient(colors: [.clear, backgroundColor], startPoint: .top, endPoint: .bottom)
                        .frame(maxWidth: .infinity)
                        .frame(height: height)
                }
            }
    }
}

extension View {
    
    func bottomFadeout(backgroundColor: Color = .init(uiColor: .systemBackground), height: CGFloat = 25) -> some View {
        modifier(BottomFadeOut(backgroundColor: backgroundColor, height: height))
    }
    
    @available(iOS 17.0, *)
    func bottomFadeout(backgroundColor: ColorResource, height: CGFloat = 25) -> some View {
        modifier(BottomFadeOut(backgroundColor: Color(backgroundColor), height: height))
    }
}
