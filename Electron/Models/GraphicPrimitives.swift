
import SwiftUI

protocol GraphicPrimitive: Identifiable, Hashable, Codable {
    var id: UUID { get }
    var position: CGPoint { get set }
    var strokeWidth: CGFloat { get set }
    var color: SDColor { get set }
    var filled: Bool { get set }
}


struct Line: GraphicPrimitive {
    var id = UUID()
    var position: CGPoint
    var strokeWidth: CGFloat
    var color: SDColor
    var filled: Bool = false // Irrelevant but satisfies protocol

    var start: CGPoint
    var end: CGPoint
}

struct RectanglePrimitive: GraphicPrimitive {
    var id = UUID()
    var position: CGPoint
    var strokeWidth: CGFloat
    var color: SDColor
    var filled: Bool

    var size: CGSize
    var cornerRadius: CGFloat
}

struct CirclePrimitive: GraphicPrimitive {
    var id = UUID()
    var position: CGPoint
    var strokeWidth: CGFloat
    var color: SDColor
    var filled: Bool

    var radius: CGFloat
}

struct ArcPrimitive: GraphicPrimitive {
    var id = UUID()
    var position: CGPoint
    var strokeWidth: CGFloat
    var color: SDColor
    var filled: Bool = false // Optional: make pie later

    var radius: CGFloat
    var startAngle: SDAngle
    var endAngle: SDAngle
    var clockwise: Bool
}

struct SDAngle: Codable, Equatable, Hashable {
    var degrees: Double

    init(_ angle: Angle) {
        self.degrees = angle.degrees
    }

    var angle: Angle {
        Angle(degrees: degrees)
    }
}


struct PolygonPrimitive: GraphicPrimitive {
    var id = UUID()
    var position: CGPoint
    var strokeWidth: CGFloat
    var color: SDColor
    var filled: Bool

    var points: [CGPoint]
    var closed: Bool
}


enum GraphicPrimitiveType: Codable, Hashable, Identifiable {
    case line(Line)
    case rectangle(RectanglePrimitive)
    case circle(CirclePrimitive)
    case arc(ArcPrimitive)
    case polygon(PolygonPrimitive)

    var id: UUID {
        switch self {
        case .line(let l): return l.id
        case .rectangle(let r): return r.id
        case .circle(let c): return c.id
        case .arc(let a): return a.id
        case .polygon(let p): return p.id
        }
    }
    
    

    var base: any GraphicPrimitive {
        switch self {
        case .line(let l): return l
        case .rectangle(let r): return r
        case .circle(let c): return c
        case .arc(let a): return a
        case .polygon(let p): return p
        }
    }
}

extension GraphicPrimitiveType {
    /// Returns a CGPath for this primitive. The `symbolCenter` is added to the primitive’s own position,
    /// converting its local coordinates into canvas coordinates.
    func cgPath(for symbolCenter: CGPoint) -> CGPath {
        switch self {
        case .line(let line):
            let p1 = CGPoint(x: symbolCenter.x + line.start.x, y: symbolCenter.y + line.start.y)
            let p2 = CGPoint(x: symbolCenter.x + line.end.x, y: symbolCenter.y + line.end.y)
            let mutablePath = CGMutablePath()
            mutablePath.move(to: p1)
            mutablePath.addLine(to: p2)
            return mutablePath
            
        case .rectangle(let rect):
            // The rectangle’s center is symbolCenter offset by rect.position.
            let center = CGPoint(x: symbolCenter.x + rect.position.x, y: symbolCenter.y + rect.position.y)
            let frame = CGRect(x: center.x - rect.size.width / 2,
                               y: center.y - rect.size.height / 2,
                               width: rect.size.width,
                               height: rect.size.height)
            return CGPath(roundedRect: frame, cornerWidth: rect.cornerRadius, cornerHeight: rect.cornerRadius, transform: nil)
            
        case .circle(let circle):
            let center = CGPoint(x: symbolCenter.x + circle.position.x, y: symbolCenter.y + circle.position.y)
            let mutablePath = CGMutablePath()
            mutablePath.addArc(center: center,
                               radius: circle.radius,
                               startAngle: 0,
                               endAngle: CGFloat.pi * 2,
                               clockwise: false)
            return mutablePath
            
        case .arc(let arc):
            let center = CGPoint(x: symbolCenter.x + arc.position.x, y: symbolCenter.y + arc.position.y)
            let mutablePath = CGMutablePath()
            mutablePath.addArc(center: center,
                               radius: arc.radius,
                               startAngle: CGFloat(arc.startAngle.angle.radians),
                               endAngle: CGFloat(arc.endAngle.angle.radians),
                               clockwise: arc.clockwise)
            return mutablePath
            
        case .polygon(let polygon):
            guard let firstPoint = polygon.points.first else { return CGMutablePath() }
            let mutablePath = CGMutablePath()
            let start = CGPoint(x: symbolCenter.x + polygon.position.x + firstPoint.x,
                                y: symbolCenter.y + polygon.position.y + firstPoint.y)
            mutablePath.move(to: start)
            for pt in polygon.points.dropFirst() {
                let point = CGPoint(x: symbolCenter.x + polygon.position.x + pt.x,
                                    y: symbolCenter.y + polygon.position.y + pt.y)
                mutablePath.addLine(to: point)
            }
            if polygon.closed {
                mutablePath.closeSubpath()
            }
            return mutablePath
        }
    }
    
    /// Uses the system-optimized CGPath hit testing.
    /// If the primitive is filled, it tests against the fill region; otherwise, it tests against a stroked version of the path.
    func systemHitTest(at point: CGPoint, symbolCenter: CGPoint, tolerance: CGFloat = 5.0) -> Bool {
        let basePath = self.cgPath(for: symbolCenter)
        
        // For filled shapes (like filled polygons or rectangles), test the fill area.
        if self.isFilled() {
            return basePath.contains(point)
        } else {
            // For non-filled shapes, generate a stroked path that reflects the visible stroke.
            // This creates a new CGPath that represents the “painted” area.
            let effectiveStrokeWidth = self.strokeWidthWithTolerance(tolerance: tolerance)
            
            let strokedPath = basePath.copy(strokingWithWidth: effectiveStrokeWidth,
                                                  lineCap: .butt,
                                                  lineJoin: .miter,
                                                  miterLimit: 10) 
            return strokedPath.contains(point)
        }
    }
    
    // Helper to determine if a primitive is to be considered filled.
    func isFilled() -> Bool {
        switch self {
        case .line:
            return false
        case .rectangle(let r):
            return r.filled
        case .circle(let c):
            return c.filled
        case .arc(let a):
            return a.filled
        case .polygon(let p):
            return p.filled
        }
    }
    
    // Helper to compute effective stroke width including tolerance.
    func strokeWidthWithTolerance(tolerance: CGFloat = 5.0) -> CGFloat {
        switch self {
        case .line(let l):
            return l.strokeWidth + tolerance
        case .rectangle(let r):
            return r.strokeWidth + tolerance
        case .circle(let c):
            return c.strokeWidth + tolerance
        case .arc(let a):
            return a.strokeWidth + tolerance
        case .polygon(let p):
            return p.strokeWidth + tolerance
        }
    }
}
