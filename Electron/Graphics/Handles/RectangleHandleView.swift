import SwiftUI

struct RectangleHandleView: View {

    var rect: RectanglePrimitive
    let size: CGFloat = 10           // easier-to-grab corner

    /// Each corner’s direction from center (dx, dy ∈ {-1, +1})
    private let cornerDirs: [CGVector] = [
        .init(dx: -1, dy: -1), // top-left
        .init(dx:  1, dy: -1), // top-right
        .init(dx: -1, dy:  1), // bottom-left
        .init(dx:  1, dy:  1)  // bottom-right
    ]

    var body: some View {
        ZStack {
            ForEach(cornerDirs, id: \.self) { dir in
                Circle()
                    .fill(.white)
                    .overlay(Circle().stroke(.blue, lineWidth: 2))
                
                    .frame(width: size, height: size)
                    .adjustedForMagnification(bounds: 1.0...5.0)
                    .offset(
                        x: dir.dx * rect.size.width  / 2,
                        y: dir.dy * rect.size.height / 2
                    )
      
            }
        }
    }
}
