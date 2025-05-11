//
//  Pad.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/5/25.
//
import SwiftUI

struct Pad: Identifiable, Codable {
    var id: UUID = UUID()
    var number: Int
    var position: SDPoint
    var shape: PadShape = .rect(width: 5, height: 10)
    var type: PadType = .surfaceMount
    var drillDiameter: Double? = nil
}

extension Pad {
    var primitives: [AnyPrimitive] {
        var padPrimitives: [AnyPrimitive] = []

        // Main pad shape (copper area)
        switch shape {
        case .rect(let width, let height):
            let rect = RectanglePrimitive(
                position: position.cgPoint,
                strokeWidth: 1.0,
                color: SDColor(color: .blue), // Customize for pad layer
                filled: true,
                size: CGSize(width: width, height: height),
                cornerRadius: 0
            )
            padPrimitives.append(.rectangle(rect))

        case .circle(let radius):
            let circle = CirclePrimitive(
                position: position.cgPoint,
                strokeWidth: 0.2,
                color: SDColor(color: .green),
                filled: true,
                radius: radius
            )
            padPrimitives.append(.circle(circle))
        }

        // Add drill hole if this is a through-hole or non-plated pad
        if type == .throughHole,
           let drill = drillDiameter {
            let drillHole = CirclePrimitive(
                position: position.cgPoint,
                strokeWidth: 0.2,
                color: SDColor(color: .black), // Or a special "cutout" color
                filled: false,
                radius: drill / 2
            )
            padPrimitives.append(.circle(drillHole))
        }

        return padPrimitives
    }

    func systemHitTest(at point: CGPoint) -> Bool {
        primitives.contains { $0.systemHitTest(at: point, symbolCenter: .zero) }
    }
}

extension Pad {
    var isCircle: Bool {
        if case .circle = shape { return true }
        return false
    }
    
    var radius: Double {
        get {
            if case let .circle(radius) = shape {
                return radius
            }
            return 0
        }
        set {
            shape = .circle(radius: newValue)
        }
    }
    
    var width: Double {
        get {
            if case let .rect(width, _) = shape {
                return width
            }
            return 0
        }
        set {
            if case let .rect(_, height) = shape {
                shape = .rect(width: newValue, height: height)
            }
        }
    }
    
    var height: Double {
        get {
            if case let .rect(_, height) = shape {
                return height
            }
            return 0
        }
        set {
            if case let .rect(width, _) = shape {
                shape = .rect(width: width, height: newValue)
            }
        }
    }
}
