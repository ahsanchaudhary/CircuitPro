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
        let scale: CGFloat = 4.0  // <--- hardcoded global scale

        switch self {
        case .line(let l):
            LineShape(
                start: CGPoint(x: l.start.x * scale, y: l.start.y * scale),
                end:   CGPoint(x: l.end.x * scale,   y: l.end.y * scale)
            )
            .stroke(l.color.color, style: StrokeStyle(lineWidth: l.strokeWidth * scale, lineCap: .round))

        case .rectangle(let r):
            let scaledSize = CGSize(width: r.size.width * scale, height: r.size.height * scale)
            RoundedRectangle(cornerRadius: r.cornerRadius * scale)
                .stroke(r.color.color, lineWidth: r.strokeWidth * scale)
                .frame(width: scaledSize.width, height: scaledSize.height)
                .background(
                    r.filled ? RoundedRectangle(cornerRadius: r.cornerRadius * scale).fill(r.color.color) : nil
                )

        case .circle(let c):
            let diameter = c.radius * 2 * scale
            Circle()
                .stroke(c.color.color, lineWidth: c.strokeWidth * scale)
                .frame(width: diameter, height: diameter)
                .background(c.filled ? Circle().fill(c.color.color) : nil)

        case .arc(let a):
            ArcShape(
                radius:     a.radius * scale,
                startAngle: .degrees(a.startAngle),
                endAngle:   .degrees(a.endAngle),
                clockwise:  a.clockwise
            )
            .stroke(a.color.color, lineWidth: a.strokeWidth * scale)
        }
    }
}
