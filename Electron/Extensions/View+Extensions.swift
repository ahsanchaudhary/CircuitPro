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
    func clipAndStroke<S: Shape>(
        with shape: S,
        strokeColor: Color = .gray.opacity(0.3),
        lineWidth: CGFloat = 1
    ) -> some View {
        self.modifier(ShapeClipStroke(shape: shape, strokeColor: strokeColor, lineWidth: lineWidth))
    }
}

