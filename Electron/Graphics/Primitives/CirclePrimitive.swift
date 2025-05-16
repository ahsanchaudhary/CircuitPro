//
//  CirclePrimitive.swift
//  Electron_Tests
//
//  Created by Giorgi Tchelidze on 5/14/25.
//
import AppKit

struct CirclePrimitive: GraphicPrimitive {
    let uuid: UUID
    var position: CGPoint      // Center point
    var radius: CGFloat
    var rotation: CGFloat
    var strokeWidth: CGFloat
    var color: SDColor
    var filled: Bool
    
    func handles() -> [Handle] {
        let rawPoint = CGPoint(x: position.x + radius, y: position.y)
        let rotated = rotate(point: rawPoint, around: position, by: rotation)
        return [Handle(kind: .circleRadius, position: rotated)]
    }


    mutating func updateHandle(
        _ kind: Handle.Kind,
        to newPos: CGPoint    ) {
        guard kind == .circleRadius else { return }

        // Calculate vector from center to new handle position
        let dx = newPos.x - position.x
        let dy = newPos.y - position.y

        // New radius is the distance
        radius = max(hypot(dx, dy), 1)

        // Rotation is the angle between center and handle
        rotation = atan2(dy, dx)
    }


    mutating func updateHandle(
        _ kind: Handle.Kind,
        to newPos: CGPoint,
        opposite _: CGPoint?)
    {
        // just forward to the existing implementation
        updateHandle(kind, to: newPos)
    }
    
    func makePath(offset: CGPoint = .zero) -> CGPath {
            let center = CGPoint(x: offset.x + position.x,
                                 y: offset.y + position.y)
            let p = CGMutablePath()
            p.addArc(center: center,
                     radius: radius,
                     startAngle: 0,
                     endAngle: .pi * 2,
                     clockwise: false)

            var t = CGAffineTransform.identity
                .translatedBy(x: center.x, y: center.y)
                .rotated(by: rotation)
                .translatedBy(x: -center.x, y: -center.y)
            return p.copy(using: &t) ?? p
        }


}

