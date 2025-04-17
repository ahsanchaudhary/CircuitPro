//
//  ViewModifiers.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/17/25.
//

import SwiftUI

struct ShapeClipStroke<S: Shape>: ViewModifier {
    let shape: S
    let strokeColor: Color
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .clipShape(shape)
            .overlay {
                shape
                    .stroke(strokeColor, lineWidth: lineWidth)
            }
    }
}
