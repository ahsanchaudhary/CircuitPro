//
//  Pin.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//
import SwiftUI

struct Pin: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var number: Int
    var position: SDPoint
    var type: PinType
    var lengthType: PinLengthType = .long
}

extension Pin {
    var length: CGFloat {
        switch lengthType {
        case .short: return 40
        case .long:  return 60
        }
    }
    
    var label: String {
        name == "" ? "Pin \(number)" : name
    }

    var primitives: [AnyPrimitive] {
        let legStart = CGPoint(x: position.x - length, y: position.y)
        let legEnd = position
        let line = LinePrimitive(strokeWidth: 1, color: .init(color: .blue), start: legStart, end: legEnd.cgPoint)
        let circle = CirclePrimitive(position: position.cgPoint, strokeWidth: 0.5, color: .init(color: .blue), filled: false, radius: 4)
        return [
            .line(line),
            .circle(circle)
        ]
    }

    func systemHitTest(at pt: CGPoint) -> Bool {
        primitives.contains { $0.systemHitTest(at: pt, symbolCenter: .zero) }
    }
}
