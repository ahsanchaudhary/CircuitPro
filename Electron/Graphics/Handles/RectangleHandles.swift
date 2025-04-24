import SwiftUI

struct RectangleHandles: View {
    @Environment(\.canvasManager) private var canvasManager

    var rect: RectanglePrimitive
    var update: (RectanglePrimitive) -> Void
    let size: CGFloat = 10           // easier-to-grab corner

    /// Each corner’s direction from center (dx, dy ∈ {-1, +1})
    private let cornerDirs: [CGVector] = [
        .init(dx: -1, dy: -1), // top-left
        .init(dx:  1, dy: -1), // top-right
        .init(dx: -1, dy:  1), // bottom-left
        .init(dx:  1, dy:  1)  // bottom-right
    ]

    // Drag-session state
    @State private var startRect: RectanglePrimitive?
    @State private var activeDir: CGVector?
    @State private var fixedCorner: CGPoint?           // ← NEW
    @State private var movingStart: CGPoint?           // ← NEW

    var body: some View {
        ZStack {
            ForEach(cornerDirs, id: \.self) { dir in
                Circle()
                    .fill(.white)
                    .overlay(Circle().stroke(.green, lineWidth: 2))
                    .frame(width: size, height: size)
                    .offset(
                        x: dir.dx * rect.size.width  / 2,
                        y: dir.dy * rect.size.height / 2
                    )
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { value in
                                // Capture initial geometry once
                                if startRect == nil {
                                    startRect  = rect
                                    activeDir  = dir

                                    let halfW = rect.size.width  / 2
                                    let halfH = rect.size.height / 2

                                    // global positions of the two corners at drag start
                                    movingStart = CGPoint(
                                        x: rect.position.x + dir.dx * halfW,
                                        y: rect.position.y + dir.dy * halfH
                                    )
                                    fixedCorner = CGPoint(
                                        x: rect.position.x - dir.dx * halfW,
                                        y: rect.position.y - dir.dy * halfH
                                    )
                                }
                                guard
                                    let original   = startRect,
                                    let fixed      = fixedCorner,
                                    let startMove  = movingStart
                                else { return }

                                // Pointer in global space, then snap
                                let rawPointer = CGPoint(
                                    x: startMove.x + value.translation.width,
                                    y: startMove.y + value.translation.height
                                )
                                let pointer = canvasManager.snap(rawPointer)

                                // New size & center from two opposite corners
                                let newWidth  = max(1, abs(pointer.x - fixed.x))
                                let newHeight = max(1, abs(pointer.y - fixed.y))
                                let newCenter = CGPoint(
                                    x: (pointer.x + fixed.x) / 2,
                                    y: (pointer.y + fixed.y) / 2
                                )

                                var updated = original
                                updated.position = newCenter
                                updated.size     = CGSize(width: newWidth,
                                                          height: newHeight)
                                update(updated)
                            }
                            .onEnded { _ in
                                // reset drag session
                                startRect   = nil
                                activeDir   = nil
                                fixedCorner = nil
                                movingStart = nil
                            }
                    )
            }
        }
        // NOTE: no extra .position() here—parent view should place this ZStack.
    }
}
