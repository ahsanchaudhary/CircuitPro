//
//  CircleTool.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/24/25.
//

import SwiftUI

struct CircleTool: GraphicsTool {
    
  var center: CGPoint?

  mutating func handleTap(at location: CGPoint) -> GraphicPrimitiveType? {
    if let c = center {
      let r = hypot(location.x - c.x, location.y - c.y)
      let prim = GraphicPrimitiveType.circle(
        .init(
          position: c,
          strokeWidth: 1,
          color: .init(color: .blue),
          filled: false,
          radius: r
        )
      )
      center = nil
      return prim
    } else {
      center = location
      return nil
    }
  }

  func preview(mousePosition: CGPoint) -> some View {
      
      
    Group {
      if let c = center {
        let radius = hypot(mousePosition.x - c.x, mousePosition.y - c.y)

        ZStack {
          // Circle outline
          Circle()
            .stroke(.blue, style: .init(lineWidth: 1, dash: [4]))
            .frame(width: radius * 2, height: radius * 2)
            .position(c)

          // Radius line
          Path { path in
            path.move(to: c)
            path.addLine(to: mousePosition)
          }
          .stroke(.gray.opacity(0.5))

          // Radius text
          Text(String(format: "%.1f", radius/4))
                .font(.caption2)
            .foregroundColor(.blue)
            .directionalPadding(vertical: 2.5, horizontal: 5)
            .background(.thinMaterial)
            .clipAndStroke(with: .capsule)
            .position(x: (c.x + mousePosition.x) / 2,
                      y: (c.y + mousePosition.y) / 2 - 10)
         
        }
        .allowsHitTesting(false)
      }
    }
  }
}
