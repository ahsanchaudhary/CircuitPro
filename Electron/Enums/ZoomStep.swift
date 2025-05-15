//
//  ZoomStep.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/11/25.
//
import SwiftUI

enum ZoomStep: CGFloat, Displayable {
    case x0_5 = 0.5
    case x0_75 = 0.75
    case x1 = 1.0
    case x1_25 = 1.25
    case x1_5 = 1.5
    case x2 = 2.0
    case x3 = 3.0
    case x4 = 4.0
    case x5 = 5.0
    case x10 = 10.0
    case x25 = 25.0
    
    static func < (lhs: ZoomStep, rhs: ZoomStep) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    var label: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let percent = rawValue * 100
        return "\(formatter.string(from: NSNumber(value: Double(percent))) ?? "\(Int(percent))")%"
    }
}
