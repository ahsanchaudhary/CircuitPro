//
//  RectangleTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/24/25.
//

import SwiftUI

struct RectangleTool: GraphicsTool {
  var start: CGPoint?

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType? {
    if let s = start {
      let rect = CGRect(origin: s, size: .zero).union(CGRect(origin: location, size: .zero))
      let center = CGPoint(x: rect.midX, y: rect.midY)
      let prim = GraphicPrimitiveType.rectangle(
        .init(
          position: center,
          strokeWidth: 1,
          color: .init(color: .green),
          filled: false,
          size: rect.size,
          cornerRadius: 0
        )
      )
      start = nil
      return prim
    } else {
      start = location
      return nil
    }
  }

  func preview(mousePosition: CGPoint) -> some View {
      Group {
          if let s = start {
              let rect = CGRect(origin: s, size: .zero).union(CGRect(origin: mousePosition, size: .zero))
              Path { $0.addRect(rect) }
                  .stroke(.green, style: .init(lineWidth: 1, dash: [4]))
                  .allowsHitTesting(false)
          }
    }
  }
}
