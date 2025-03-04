//
//  InsettableShape+Extension.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 05/03/2025.
//

import SwiftUI

extension InsettableShape {
    
    @ViewBuilder
    func optionalStrokeBorder(lineWidth: CGFloat, condition: Bool) -> some View {
        if condition {
            self.strokeBorder(lineWidth: lineWidth)
        } else  {
            self
        }
    }
}
