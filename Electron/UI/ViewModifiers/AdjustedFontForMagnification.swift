//
//  AdjustedFontForMagnification.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/2/25.
//


import SwiftUI

struct AdjustedFontForMagnification: ViewModifier {
    @Environment(ScrollViewManager.self) private var scrollViewManager
    
    var baseSize: CGFloat
    var bounds: ClosedRange<Double> = 1.0...Double.infinity

    func body(content: Content) -> some View {
        let rawMagnification = scrollViewManager.currentMagnification
        let clampedMagnification = bounds.clamp(rawMagnification)

        return content
            .font(.system(size: baseSize * clampedMagnification))
            .scaleEffect(1 / clampedMagnification, anchor: .center)

    }
}

extension View {
    /// Keeps text visually consistent by adjusting for scroll view magnification.
    func adjustedFontForMagnification(baseSize: CGFloat, bounds: ClosedRange<Double> = 1.0...Double.infinity) -> some View {
        self.modifier(AdjustedFontForMagnification(baseSize: baseSize, bounds: bounds))
    }
}
