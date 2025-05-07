//
//  Render.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/22/25.
//
import SwiftUI

extension AnyPrimitive {
  @ViewBuilder
  func render() -> some View {
    switch self {
    case .line(let l):
      LineShape(start: l.start, end: l.end)
            .stroke(l.color.color, style: StrokeStyle(lineWidth: l.strokeWidth, lineCap: .round))


    case .rectangle(let r):
      RoundedRectangle(cornerRadius: r.cornerRadius)
            .stroke(r.color.color, lineWidth: r.strokeWidth)
            .frame(width: r.size.width, height: r.size.height)
        
            .background(r.filled ? RoundedRectangle(cornerRadius: r.cornerRadius).fill(r.color.color) : nil)


    case .circle(let c):
      Circle()
            .stroke(c.color.color, lineWidth: c.strokeWidth)
        .frame(width: c.radius*2, height: c.radius*2)
        .background(c.filled ? Circle().fill(c.color.color) : nil)


    case .arc(let a):
      ArcShape(radius:    a.radius,
               startAngle:.degrees(a.startAngle),
               endAngle:  .degrees(a.endAngle),
               clockwise: a.clockwise)
      .stroke(a.color.color, lineWidth: a.strokeWidth)
    }
  }
}
