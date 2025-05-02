//
//  View+Extensions.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/4/25.
//

import SwiftUI

// Helper to conditionally apply modifiers
extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}




extension View {
    func disableAnimations() -> some View {
        self.transaction { transaction in
            transaction.animation = nil
        }
    }
}

extension View {
    func enableAnimations(_ animation: Animation? = .default) -> some View {
        self.transaction { transaction in
            transaction.animation = animation
        }
    }
}


