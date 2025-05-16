//
//  CanvasElement.swift
//  Electron_Tests
//
//  Created by Giorgi Tchelidze on 5/15/25.
//
import SwiftUI

enum CanvasElement: Identifiable, Hashable {
    case primitive(AnyPrimitive)
    case pin(Pin)

    var id: UUID {
        switch self {
        case .primitive(let p): return p.id
        case .pin(let pin):     return pin.id
        }
    }

    var primitives: [AnyPrimitive] {
        switch self {
        case .primitive(let p): return [p]
        case .pin(let pin):     return pin.primitives
        }
    }
    
    var isPrimitiveEditable: Bool {
           switch self {
           case .primitive: return true
           case .pin:       return false
           }
       }
    
    var debugDescription: String {
        switch self {
        case .primitive(let p): return "\(p)"
        case .pin(let pin):     return "\(pin)"
        }
    }
    
    var rotationDescription: String {
        switch self {
        case .primitive(let p): return "\(p.rotation * 180 / .pi)"
        default:
                return "no rotation"
        }
    }

    func draw(in ctx: CGContext, selected: Bool) {

        switch self {

        // ── Graphic primitives ───────────────────────────────────────────────
        case .primitive(let prim):
            prim.draw(in: ctx, selected: selected)      // ← your AnyPrimitive-extension

        // ── Pins ─────────────────────────────────────────────────────────────
        case .pin(let pin):
            pin.draw(in: ctx,
                     showText: true,
                     highlight: selected)
        }
    }

    func systemHitTest(at point: CGPoint) -> Bool {
        primitives.contains { $0.systemHitTest(at: point) }
    }

    func handles() -> [Handle] {
        primitives.flatMap { $0.handles() }
    }

    mutating func updateHandle(_ kind: Handle.Kind, to point: CGPoint, opposite: CGPoint?) {
        var updatedPrims = primitives
        for i in updatedPrims.indices {
            updatedPrims[i].updateHandle(kind, to: point, opposite: opposite)
        }
        switch self {
        case .primitive:
            if updatedPrims.count == 1, let p = updatedPrims.first {
                self = .primitive(p)
            }
        case .pin(var pin):
            pin = Pin(
                id: pin.id,
                name: pin.name,
                number: pin.number,
                position: point, // crude; depends on your logic
                type: pin.type,
                lengthType: pin.lengthType
            )
            self = .pin(pin)
        }
    }
    
    mutating func translate(by delta: CGPoint) {
        switch self {
        case .primitive(var p):
            p.position.x += delta.x
            p.position.y += delta.y
            self = .primitive(p) // ✅ REASSIGN to mutate enum
        case .pin(var pin):
            pin.position.x += delta.x
            pin.position.y += delta.y
            self = .pin(pin)     // ✅ REASSIGN to mutate enum
        }
    }



}

extension CanvasElement {
    var isPin: Bool {
        if case .pin = self { return true } else { return false }
    }
}

// MARK: - CanvasElement bounding box
extension CanvasElement {
    var boundingBox: CGRect {
        primitives.map { $0.makePath().boundingBoxOfPath }
                  .reduce(.null, { $0.union($1) })
    }
}
