//
//  RectangleHandles.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/22/25.
//
import SwiftUI
struct RectangleHandles: View {
  var rect: RectanglePrimitive
  var update: (RectanglePrimitive) -> Void
  let size: CGFloat = 10   // your larger, easier‑to‑grab handle

  // Each corner’s direction from center (dx, dy ∈ {‑1, +1})
  private let cornerDirs: [CGVector] = [
    CGVector(dx: -1, dy: -1), // top‑left
    CGVector(dx:  1, dy: -1), // top‑right
    CGVector(dx: -1, dy:  1), // bottom‑left
    CGVector(dx:  1, dy:  1)  // bottom‑right
  ]

  // Freeze the state at drag start
  @State private var startRect: RectanglePrimitive?
  @State private var activeDir: CGVector?

  var body: some View {
    ZStack {
      ForEach(cornerDirs, id: \.self) { dir in
        Circle()
          .fill(Color.white)
          .overlay(Circle().stroke(Color.green, lineWidth: 2))
          .frame(width: size, height: size)
          // place handle at the correct corner in local coords
          .offset(
            x: dir.dx * rect.size.width  / 2,
            y: dir.dy * rect.size.height / 2
          )
          .highPriorityGesture(
            DragGesture()
              .onChanged { value in
                // 1️⃣ On first drag update, capture the starting rect and which corner
                if startRect == nil {
                  startRect = rect
                  activeDir = dir
                }
                guard
                  let original = startRect,
                  let d = activeDir
                else { return }

                // 2️⃣ Compute original corner positions in LOCAL coords
                let halfW = original.size.width  / 2
                let halfH = original.size.height / 2
                let moving = CGPoint(x:  d.dx * halfW,
                                     y:  d.dy * halfH)
                let fixed  = CGPoint(x: -d.dx * halfW,
                                     y: -d.dy * halfH)

                // 3️⃣ Apply the gesture’s translation to the moving corner
                let newMoving = CGPoint(
                  x: moving.x + value.translation.width,
                  y: moving.y + value.translation.height
                )

                // 4️⃣ Build the new rectangle in LOCAL space
                let minX = min(newMoving.x, fixed.x)
                let maxX = max(newMoving.x, fixed.x)
                let minY = min(newMoving.y, fixed.y)
                let maxY = max(newMoving.y, fixed.y)

                let newWidth  = max(1, maxX - minX)
                let newHeight = max(1, maxY - minY)
                let localCenter = CGPoint(
                  x: (minX + maxX) / 2,
                  y: (minY + maxY) / 2
                )

                // 5️⃣ Convert local center back to GLOBAL coords:
                //    original.position is the old global center
                let globalCenter = CGPoint(
                  x: original.position.x + localCenter.x,
                  y: original.position.y + localCenter.y
                )

                // 6️⃣ Write back to the primitive
                var updated = original
                updated.position = globalCenter
                updated.size     = CGSize(width: newWidth,
                                          height: newHeight)
                update(updated)
              }
              .onEnded { _ in
                // reset for next drag
                startRect = nil
                activeDir = nil
              }
          )
      }
    }
    // ← NO .position or .offset here!  renderFullView() already moves this ZStack
  }
}
