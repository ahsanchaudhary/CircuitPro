import AppKit

struct RectanglePrimitive: GraphicPrimitive {
    let uuid: UUID
    var position: CGPoint
    var size: CGSize
    var rotation: CGFloat
    var strokeWidth: CGFloat
    var color: SDColor
    var filled: Bool
    
    func handles() -> [Handle] {
        let halfW = size.width / 2
        let halfH = size.height / 2

        let tl = CGPoint(x: position.x - halfW, y: position.y + halfH)
        let tr = CGPoint(x: position.x + halfW, y: position.y + halfH)
        let br = CGPoint(x: position.x + halfW, y: position.y - halfH)
        let bl = CGPoint(x: position.x - halfW, y: position.y - halfH)

        return [
            Handle(kind: .rectTopLeft,     position: rotate(point: tl, around: position, by: rotation)),
            Handle(kind: .rectTopRight,    position: rotate(point: tr, around: position, by: rotation)),
            Handle(kind: .rectBottomRight, position: rotate(point: br, around: position, by: rotation)),
            Handle(kind: .rectBottomLeft,  position: rotate(point: bl, around: position, by: rotation))
        ]

    }



    mutating func updateHandle(
        _        kind: Handle.Kind,
        to       drag: CGPoint,
        opposite opp: CGPoint?)          // opp is in WORLD space
    {
        guard let opp = opp else { return }

        // Accept only corner kinds
        switch kind {
        case .rectTopLeft, .rectTopRight,
             .rectBottomRight, .rectBottomLeft:

            // Unit vectors along the rectangle’s local X and Y axes
            let ux = CGVector(dx:  cos(rotation), dy:  sin(rotation))
            let uy = CGVector(dx: -sin(rotation), dy:  cos(rotation))

            // Vector from opposite corner to dragged corner (world space)
            let d  = CGVector(dx: drag.x - opp.x, dy: drag.y - opp.y)

            // Width and height are just the projections of d onto ux / uy
            let w = abs(d.dx * ux.dx + d.dy * ux.dy)
            let h = abs(d.dx * uy.dx + d.dy * uy.dy)

            size     = CGSize(width: max(w, 1), height: max(h, 1))
            position = CGPoint(x: (drag.x + opp.x) * 0.5,
                               y: (drag.y + opp.y) * 0.5)

        default: break
        }
    }
    
    func makePath(offset: CGPoint = .zero) -> CGPath {

         // 1. build an *unrotated* rectangle whose centre is position + offset
         let centre = CGPoint(x: offset.x + position.x,
                              y: offset.y + position.y)

         let frame  = CGRect(x: centre.x - size.width  * 0.5,
                             y: centre.y - size.height * 0.5,
                             width : size.width,
                             height: size.height)

         let p = CGMutablePath()
         p.addRect(frame)

         // 2. apply the primitive’s rotation about the rectangle centre
         var t = CGAffineTransform.identity
                .translatedBy(x: centre.x, y: centre.y)
                .rotated(by: rotation)
                .translatedBy(x: -centre.x, y: -centre.y)

         return p.copy(using: &t) ?? p
     }
    
    
    



}
