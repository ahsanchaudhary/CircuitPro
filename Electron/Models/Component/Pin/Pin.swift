//
//  Pin.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//
import SwiftUI

struct Pin: Identifiable, Codable {
    var id: UUID = UUID()
    var number: Int
    var position: SDPoint
    var type: PinType
    var lengthType: PinLengthType = .long
}

extension Pin {
    var length: CGFloat {
        switch lengthType {
        case .short: return 35
        case .long:  return 55
        }
    }

    var primitives: [GraphicPrimitiveType] {
        let legStart = CGPoint(x: position.x - length, y: position.y)
        let legEnd = position
        let line = LinePrimitive(strokeWidth: 2, color: .init(color: .blue), start: legStart, end: legEnd.cgPoint)
        let circle = CirclePrimitive(position: position.cgPoint, strokeWidth: 1, color: .init(color: .blue), filled: false, radius: 5)
        return [
            .line(line),
            .circle(circle)
        ]
    }

    func systemHitTest(at pt: CGPoint) -> Bool {
        primitives.contains { $0.systemHitTest(at: pt, symbolCenter: .zero) }
    }
}
