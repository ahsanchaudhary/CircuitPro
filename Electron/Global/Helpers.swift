import SwiftUI


func rotate(point: CGPoint, around center: CGPoint, by angle: CGFloat) -> CGPoint {
    let dx = point.x - center.x
    let dy = point.y - center.y
    let cosA = cos(angle)
    let sinA = sin(angle)
    return CGPoint(
        x: center.x + dx * cosA - dy * sinA,
        y: center.y + dx * sinA + dy * cosA
    )
}

func unrotate(point: CGPoint, around center: CGPoint, by angle: CGFloat) -> CGPoint {
    rotate(point: point, around: center, by: -angle)
}
