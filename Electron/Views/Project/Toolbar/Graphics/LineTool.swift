//
//  LineTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/24/25.
//


import SwiftUI


struct LineTool: GraphicsTool {
  var start: CGPoint?

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType? {
    if let s = start {
      let line = GraphicPrimitiveType.line(
        .init(strokeWidth: 1, color: .init(color: .orange), start: s, end: location)
      )
      start = nil
      return line
    } else {
      start = location
      return nil
    }
  }

  func preview(mousePosition: CGPoint) -> some View {
      Group {
          if let s = start {
              Path { $0.move(to: s); $0.addLine(to: mousePosition) }
                  .stroke(.orange, style: .init(lineWidth: 1, dash: [4]))
                  .allowsHitTesting(false)
          }
      }
  }
}