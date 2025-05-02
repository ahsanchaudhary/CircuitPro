//
//  AdjustedForMagnification.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//

import SwiftUI

struct AdjustedForMagnification: ViewModifier {
    @Environment(\.scrollViewManager) private var scrollViewManager
    var bounds: ClosedRange<Double> = 1.0...Double.infinity

    func body(content: Content) -> some View {
        let rawMagnification = scrollViewManager.currentMagnification
        let clampedMagnification = bounds.clamp(rawMagnification)

        return content
            .scaleEffect(1 / clampedMagnification, anchor: .center)
    }
}

extension View {
    func adjustedForMagnification(bounds: ClosedRange<Double> = 1.0...Double.infinity) -> some View {
        self.modifier(AdjustedForMagnification(bounds: bounds))
    }
}

// Clamp helper
private extension ClosedRange where Bound: Comparable {
    func clamp(_ value: Bound) -> Bound {
        return Swift.min(Swift.max(lowerBound, value), upperBound)
    }
}

import SwiftUI

struct AdjustedFontForMagnification: ViewModifier {
    @Environment(\.scrollViewManager) private var scrollViewManager
    var baseSize: CGFloat
    var bounds: ClosedRange<Double> = 1.0...Double.infinity

    func body(content: Content) -> some View {
        let rawMagnification = scrollViewManager.currentMagnification
        let clampedMagnification = bounds.clamp(rawMagnification)

        return content
            .scaleEffect(1 / clampedMagnification, anchor: .center)
            .font(.system(size: baseSize * clampedMagnification))
    }
}

extension View {
    /// Keeps text visually consistent by adjusting for scroll view magnification.
    func adjustedFontForMagnification(baseSize: CGFloat, bounds: ClosedRange<Double> = 1.0...Double.infinity) -> some View {
        self.modifier(AdjustedFontForMagnification(baseSize: baseSize, bounds: bounds))
    }
}



