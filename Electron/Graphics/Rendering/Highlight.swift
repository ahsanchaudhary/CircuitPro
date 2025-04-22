//
//  Highlight.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/22/25.
//
import SwiftUI


extension GraphicPrimitiveType {
  @ViewBuilder
  func highlightBackground() -> some View {
    switch self {
    case .line(let l):
      LineShape(start: l.start, end: l.end)
            .stroke(l.color.color.opacity(0.3), style: StrokeStyle(lineWidth: l.strokeWidth + 5, lineCap: .round))

    case .rectangle(let r):
      RoundedRectangle(cornerRadius: r.cornerRadius)
            .stroke(r.color.color.opacity(0.3), style: StrokeStyle(lineWidth: r.strokeWidth + 5, lineJoin: .round))

        .frame(width: r.size.width, height: r.size.height)

    case .circle(let c):
      Circle()
        .stroke(c.color.color.opacity(0.3), lineWidth: c.strokeWidth + 5)
        .frame(width: c.radius * 2, height: c.radius * 2)

    case .arc(let a):
      ArcShape(
        radius: a.radius,
        startAngle: .degrees(a.startAngle),
        endAngle: .degrees(a.endAngle),
        clockwise: a.clockwise
      )
      .stroke(a.color.color.opacity(0.3), lineWidth: a.strokeWidth + 5)
    }
  }
}
