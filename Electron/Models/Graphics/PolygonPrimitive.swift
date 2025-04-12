//
//  PolygonPrimitive.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/12/25.
//
import SwiftUI

struct PolygonPrimitive: GraphicPrimitive {
    var id = UUID()
    var position: CGPoint
    var strokeWidth: CGFloat
    var color: SDColor
    var filled: Bool

    var points: [CGPoint]
    var closed: Bool
}
