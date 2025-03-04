//
//  View+Extension.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 05/03/2025.
//

import SwiftUI

extension View {
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func modify<Content: View>(@ViewBuilder _ transform: (Self) -> Content?) -> some View {
        if let view = transform(self) {
            view
        } else {
            self
        }
    }
    
    func onReceive(notification: Notification.Name, perform action: @escaping (NotificationCenter.Publisher.Output) -> Void) -> some View {
        onReceive(NotificationCenter.default.publisher(for: notification), perform: action)
    }
    
    func willEnterForeground(perform action: @escaping () -> Void) -> some View {
        self.onReceive(notification: UIApplication.willEnterForegroundNotification) { _ in action() }
    }
    
    func onBecomeActive(perform action: @escaping () -> Void) -> some View {
        self.onReceive(notification: UIApplication.didBecomeActiveNotification) { _ in action() }
    }
    
    func leadingAligned() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func trailingAligned() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
}
