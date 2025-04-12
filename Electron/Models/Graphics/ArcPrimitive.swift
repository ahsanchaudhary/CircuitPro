//
//  ArcPrimitive.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/12/25.
//

import SwiftUI

struct ArcPrimitive: GraphicPrimitive {
    var id = UUID()
    var position: CGPoint
    var strokeWidth: CGFloat
    var color: SDColor
    var filled: Bool = false // Optional: make pie later

    var radius: CGFloat
    var startAngle: CGFloat
    var endAngle: CGFloat
    var clockwise: Bool
}
