//
//  SDPoint.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/14/25.
//
import SwiftUI

struct SDPoint: Codable {
    var x: CGFloat
    var y: CGFloat

    init(_ point: CGPoint) {
        self.x = point.x
        self.y = point.y
    }

    var cgPoint: CGPoint {
        CGPoint(x: x, y: y)
    }
}
