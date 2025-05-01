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

