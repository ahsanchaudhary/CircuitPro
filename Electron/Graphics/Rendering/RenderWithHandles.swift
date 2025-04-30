//
//  RenderWithHandles.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//
import SwiftUI

extension GraphicPrimitiveType {
  @ViewBuilder
  func renderWithHandles(
    isSelected: Bool,
    binding: Binding<GraphicPrimitiveType>,
    dragOffset: CGSize,
    opacity: Double
  ) -> some View {
    ZStack {
      render()               // draw the shape at (0,0)
      if isSelected {
        highlightBackground()
        Self.handles(for: binding)  // draws handle(s) positioned via offset
      }
    }
    // ← here we move the *entire* ZStack to its real on‑canvas position
    .if(!self.isLine) { $0.position(self.position) }
    .offset(dragOffset)
    .opacity(opacity)
  }
}
