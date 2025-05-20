import Foundation
import CoreGraphics
import AppKit

/// A type-erased wrapper so we can store heterogeneous primitives in one array.
enum AnyPrimitive: GraphicPrimitive, Codable, Hashable {

    case circle   (CirclePrimitive)
    case rectangle(RectanglePrimitive)
    case line     (LinePrimitive)

    var uuid: UUID {
        switch self {
        case .circle   (let p): return p.uuid
        case .rectangle(let p): return p.uuid
        case .line     (let p): return p.uuid
        }
    }

    var id: UUID { uuid }

    //MARK: - Mutating accessors that need to write back into enum
    var position: CGPoint {
        get {
            switch self {
            case .circle   (let p): return p.position
            case .rectangle(let p): return p.position
            case .line     (let p): return p.position
            }
        }
        set {
            switch self {
            case .circle   (var p): p.position = newValue; self = .circle(p)
            case .rectangle(var p): p.position = newValue; self = .rectangle(p)
            case .line     (var p): p.position = newValue; self = .line(p)
            }
        }
    }

    var rotation: CGFloat {
        get {
            switch self {
            case .circle   (let p): return p.rotation
            case .rectangle(let p): return p.rotation
            case .line     (let p): return p.rotation
            }
        }
        set {
            switch self {
            case .circle   (var p): p.rotation = newValue; self = .circle(p)
            case .rectangle(var p): p.rotation = newValue; self = .rectangle(p)
            case .line     (var p): p.rotation = newValue; self = .line(p)
            }
        }
    }

    var strokeWidth: CGFloat {
        get {
            switch self {
            case .circle   (let p): return p.strokeWidth
            case .rectangle(let p): return p.strokeWidth
            case .line     (let p): return p.strokeWidth
            }
        }
        set {
            switch self {
            case .circle   (var p): p.strokeWidth = newValue; self = .circle(p)
            case .rectangle(var p): p.strokeWidth = newValue; self = .rectangle(p)
            case .line     (var p): p.strokeWidth = newValue; self = .line(p)
            }
        }
    }

    var color: SDColor {
        get {
            switch self {
            case .circle   (let p): return p.color
            case .rectangle(let p): return p.color
            case .line     (let p): return p.color
            }
        }
        set {
            switch self {
            case .circle   (var p): p.color = newValue; self = .circle(p)
            case .rectangle(var p): p.color = newValue; self = .rectangle(p)
            case .line     (var p): p.color = newValue; self = .line(p)
            }
        }
    }

    var filled: Bool {
        get {
            switch self {
            case .circle   (let p): return p.filled
            case .rectangle(let p): return p.filled
            case .line     (let p): return p.filled
            }
        }
        set {
            switch self {
            case .circle   (var p): p.filled = newValue; self = .circle(p)
            case .rectangle(var p): p.filled = newValue; self = .rectangle(p)
            case .line     (var p): p.filled = newValue; self = .line(p)
            }
        }
    }

    // MARK: - Unified Path
    func makePath(offset: CGPoint = .zero) -> CGPath {
        switch self {
        case .circle   (let p): return p.makePath(offset: offset)
        case .rectangle(let p): return p.makePath(offset: offset)
        case .line     (let p): return p.makePath(offset: offset)
        }
    }

    // MARK: - Hit Testing
    func systemHitTest(at point: CGPoint, tolerance: CGFloat = 5) -> Bool {
        let path = makePath()
        if filled {
            return path.contains(point)
        } else {
            let fat = path.copy(strokingWithWidth: strokeWidth + tolerance,
                                lineCap: .round,
                                lineJoin: .round,
                                miterLimit: 10)
            return fat.contains(point)
        }
    }

    func handles() -> [Handle] {
        switch self {
        case .circle   (let p): return p.handles()
        case .rectangle(let p): return p.handles()
        case .line     (let p): return p.handles()
        }
    }

    mutating func updateHandle(_ kind: Handle.Kind,
                               to newPos: CGPoint,
                               opposite opp: CGPoint? = nil)
    {
        switch self {
        case .circle   (var p): p.updateHandle(kind, to: newPos, opposite: opp); self = .circle(p)
        case .rectangle(var p): p.updateHandle(kind, to: newPos, opposite: opp); self = .rectangle(p)
        case .line     (var p): p.updateHandle(kind, to: newPos, opposite: opp); self = .line(p)
        }
    }
}

// MARK: - Convenience rendering helper
extension AnyPrimitive {

    /// Draws the primitive on `ctx`.
    /// When `selected == true` a blue “halo” is rendered.
    func draw(in ctx: CGContext, selected: Bool) {

        let path = makePath()

        // main fill / stroke
        if filled {
            ctx.setFillColor(color.cgColor)
            ctx.addPath(path)
            ctx.fillPath()
        } else {
            ctx.setStrokeColor(color.cgColor)
            ctx.setLineWidth(strokeWidth)
            ctx.setLineCap(.round)
            ctx.addPath(path)
            ctx.strokePath()
        }

        // optional selection halo
        if selected {
            let haloWidth = max(strokeWidth * 2, strokeWidth + 3)
            let haloColor = CGColor(red:   CGFloat(color.red),
                                    green: CGFloat(color.green),
                                    blue:  CGFloat(color.blue),
                                    alpha: 0.4)
            ctx.setStrokeColor(haloColor)
            ctx.setLineWidth(haloWidth)
            ctx.setLineCap(.round)
            ctx.addPath(path)
            ctx.strokePath()
        }
    }
}
