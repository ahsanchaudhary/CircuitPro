//
//  Line.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/12/25.
//

import SwiftUI

struct Line: GraphicPrimitive {
    var id = UUID()
    var position: CGPoint
    var strokeWidth: CGFloat
    var color: SDColor
    var filled: Bool = false 

    var start: CGPoint
    var end: CGPoint
}
