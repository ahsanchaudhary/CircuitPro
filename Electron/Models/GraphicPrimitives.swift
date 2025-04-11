//
//  GraphicPrimitives.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/11/25.
//

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
