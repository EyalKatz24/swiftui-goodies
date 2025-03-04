//
//  OnFirstAppear.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 05/03/2025.
//

import SwiftUI

fileprivate struct OnFirstAppearModifier: ViewModifier {
    @State private var firstTime: Bool = true
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)?) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if firstTime {
                    firstTime = false
                    action?()
                }
            }
    }
}

extension View {
    
    func onFirstAppear(perform: (() -> Void)?) -> some View {
        modifier(OnFirstAppearModifier(perform: perform))
    }
}
