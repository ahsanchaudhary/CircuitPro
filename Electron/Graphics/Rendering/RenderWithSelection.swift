//
//  RenderFull.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/22/25.
//
import SwiftUI

extension AnyPrimitive {
  @ViewBuilder
  func renderWithSelection(
    isSelected: Bool,
    dragOffset: CGSize,
    opacity: Double
  ) -> some View {
    ZStack {
      render()               // draw the shape at (0,0)
      if isSelected {
        highlightBackground()

      }
    }
    // ← here we move the *entire* ZStack to its real on‑canvas position
    .if(!self.isLine) { $0.position(self.position) }
    .offset(dragOffset)
    .opacity(opacity)
  }
}
