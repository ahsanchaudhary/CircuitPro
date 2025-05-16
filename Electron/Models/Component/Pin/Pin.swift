//
//  Pin.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/30/25.
//
import SwiftUI

struct Pin: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var number: Int
    var position: CGPoint
    var type: PinType
    var lengthType: PinLengthType = .long
    var showLabel: Bool = true
    var showNumber: Bool = true
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
        let line = LinePrimitive(uuid: UUID(), start: legStart, end: legEnd, strokeWidth: 1, color: .init(color: .blue))
        let circle = CirclePrimitive(uuid: .init(), position: position, radius: 4, rotation: 0, strokeWidth: 1, color: .init(color: .blue), filled: false)
        return [
            .line(line),
            .circle(circle)
        ]
    }

    func systemHitTest(at pt: CGPoint) -> Bool {
        primitives.contains { $0.systemHitTest(at: pt) }
    }
}


