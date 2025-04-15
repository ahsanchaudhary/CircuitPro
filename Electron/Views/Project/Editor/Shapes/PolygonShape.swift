//
//  PolygonShape.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/16/25.
//


import SwiftUI



struct PolygonShape: Shape {
    var points: [CGPoint]
    var closed: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: first)
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        if closed {
            path.closeSubpath()
        }
        return path
    }
}
