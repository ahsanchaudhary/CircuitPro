//
//  ArcShape.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/16/25.
//


import SwiftUI



struct ArcShape: Shape {
    var radius: CGFloat
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: .zero,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: clockwise)
        return path
    }
}
