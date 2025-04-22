//
//  CircleHandles.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/22/25.
//
import SwiftUI

struct CircleHandles: View {
  var circle: CirclePrimitive
  var update: (CirclePrimitive) -> Void
  let size: CGFloat = 10
  
  @State private var direction: CGVector = .init(dx: 1, dy: 0)

  // Offset for the radius handle
  private var handleOffset: CGSize {
    CGSize(
      width: direction.dx * circle.radius,
      height: direction.dy * circle.radius
    )
  }

  var body: some View {
    ZStack {
      // Center handle marker
      Circle()
            .fill(.blue)
        .frame(width: size, height: size)
        // static center point

      // Radius handle
      Circle()
        .fill(Color.white)
        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
        .frame(width: size, height: size)
        .offset(handleOffset)
        .gesture(
          DragGesture()
            .onChanged { value in
              let dx = value.location.x
              let dy = value.location.y
              let dist = max(1, hypot(dx, dy))

              // update direction and radius
              direction = CGVector(dx: dx / dist, dy: dy / dist)
              var updated = circle
              updated.radius = dist
              update(updated)
            }
        )
    }
  }
}
