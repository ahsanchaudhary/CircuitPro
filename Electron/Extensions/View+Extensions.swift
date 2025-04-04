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
