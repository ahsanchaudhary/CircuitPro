//
//  CGPoint+Extensions.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/4/25.
//
import SwiftUI

extension CGPoint {

    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs
    }

    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs - rhs
    }

    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
   
}

extension CGPoint {
    static let canvasCenter = CGPoint(x: 1500, y: 1500)
    
    var shiftedByCenter: CGPoint {
        self + .canvasCenter
    }
}

extension CGPoint {
    init(_ sdPoint: SDPoint) {
        self.init(x: sdPoint.x, y: sdPoint.y)
    }
}
