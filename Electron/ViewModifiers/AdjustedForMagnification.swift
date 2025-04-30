//
//  AdjustedForMagnification.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//

import SwiftUI

struct AdjustedForMagnification: ViewModifier {
    @Environment(\.scrollViewManager) private var scrollViewManager
    var preventUpscaling: Bool = true

    func body(content: Content) -> some View {
        let rawMagnification = scrollViewManager.currentMagnification
        let magnification = (preventUpscaling && rawMagnification < 1) ? 1 : rawMagnification

        return content
            .scaleEffect(1 / magnification)
    }
}

extension View {
    func adjustedForMagnification(preventUpscaling: Bool = true) -> some View {
        self.modifier(AdjustedForMagnification(preventUpscaling: preventUpscaling))
    }
}
