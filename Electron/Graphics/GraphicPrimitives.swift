
import SwiftUI

enum GraphicPrimitiveType: Codable, Hashable, Identifiable {
    case line(LinePrimitive)
    case rectangle(RectanglePrimitive)
    case circle(CirclePrimitive)
    case arc(ArcPrimitive)

    var id: UUID {
        switch self {
        case .line(let l): return l.id
        case .rectangle(let r): return r.id
        case .circle(let c): return c.id
        case .arc(let a): return a.id
        }
    }
    
    

    var base: any GraphicPrimitive {
        switch self {
        case .line(let l): return l
        case .rectangle(let r): return r
        case .circle(let c): return c
        case .arc(let a): return a
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
                               startAngle: arc.startAngle.radians,
                               endAngle: arc.endAngle.radians,
                               clockwise: arc.clockwise)

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
        }
    }
}

extension GraphicPrimitiveType {
  @ViewBuilder
  func render() -> some View {
    switch self {
    case .line(let l):
      LineShape(start: l.start, end: l.end)
            .stroke(l.color.color, style: StrokeStyle(lineWidth: l.strokeWidth, lineCap: .round))


    case .rectangle(let r):
      RoundedRectangle(cornerRadius: r.cornerRadius)
            .stroke(r.color.color, lineWidth: r.strokeWidth)
            .frame(width: r.size.width, height: r.size.height)
        
            .background(r.filled ? RoundedRectangle(cornerRadius: r.cornerRadius).fill(r.color.color) : nil)


    case .circle(let c):
      Circle()
            .stroke(c.color.color, lineWidth: c.strokeWidth)
        .frame(width: c.radius*2, height: c.radius*2)
        .background(c.filled ? Circle().fill(c.color.color) : nil)


    case .arc(let a):
      ArcShape(radius:    a.radius,
               startAngle:.degrees(a.startAngle),
               endAngle:  .degrees(a.endAngle),
               clockwise: a.clockwise)
      .stroke(a.color.color, lineWidth: a.strokeWidth)
    }
  }
}

extension GraphicPrimitiveType {
  @ViewBuilder
  func highlightBackground() -> some View {
    switch self {
    case .line(let l):
      LineShape(start: l.start, end: l.end)
            .stroke(l.color.color.opacity(0.3), style: StrokeStyle(lineWidth: l.strokeWidth + 5, lineCap: .round))

    case .rectangle(let r):
      RoundedRectangle(cornerRadius: r.cornerRadius)
            .stroke(r.color.color.opacity(0.3), style: StrokeStyle(lineWidth: r.strokeWidth + 5, lineJoin: .round))

        .frame(width: r.size.width, height: r.size.height)

    case .circle(let c):
      Circle()
        .stroke(c.color.color.opacity(0.3), lineWidth: c.strokeWidth + 5)
        .frame(width: c.radius * 2, height: c.radius * 2)

    case .arc(let a):
      ArcShape(
        radius: a.radius,
        startAngle: .degrees(a.startAngle),
        endAngle: .degrees(a.endAngle),
        clockwise: a.clockwise
      )
      .stroke(a.color.color.opacity(0.3), lineWidth: a.strokeWidth + 5)
    }
  }
}




extension GraphicPrimitiveType {
  var position: CGPoint {
    get {
      switch self {
      case .line(let l):       return l.position
      case .rectangle(let r):  return r.position
      case .circle(let c):     return c.position
      case .arc(let a):        return a.position
      }
    }
    mutating set {
      switch self {
      case .line(var l):
        let dx = newValue.x - l.position.x
        let dy = newValue.y - l.position.y
        l.start.x += dx; l.start.y += dy
        l.end.x   += dx; l.end.y   += dy
        l.position = newValue
        self = .line(l)

      case .rectangle(var r):
        r.position = newValue
        self = .rectangle(r)

      case .circle(var c):
        c.position = newValue
        self = .circle(c)

      case .arc(var a):
        a.position = newValue
        self = .arc(a)
      }
    }
  }
}

extension GraphicPrimitiveType {
  var isLine: Bool {
    if case .line = self { return true }
    return false
  }
}
