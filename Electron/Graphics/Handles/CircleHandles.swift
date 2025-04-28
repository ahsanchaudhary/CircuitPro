//
//  CircleHandles.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/22/25.
//
import SwiftUI

struct CircleHandles: View {
    @Environment(\.canvasManager) private var canvasManager
    
  var circle: CirclePrimitive
  var update: (CirclePrimitive) -> Void
  let size: CGFloat = 10
  

    private var handleOffset: CGSize {
      CGSize(width: circle.radius, height: 0)
    }


  var body: some View {
    ZStack {
      // Center handle marker
//      Circle()
//            .fill(.blue)
//        .frame(width: size, height: size)
//        // static center point

      // Radius handle
      Circle()
        .fill(Color.white)
        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
        .frame(width: size, height: size)
        .offset(handleOffset)
        .contentShape(Rectangle()) // <- This makes the tap area larger
        .frame(width: 30, height: 30)
        .gesture(
          DragGesture()
            .onChanged { value in
              // Snap the drag location
              let snapped = canvasManager.snap(value.location)

              // Distance from origin along +X only (ignore Y)
              let dist = max(1, snapped.x) // prevent radius going below 1pt

              var updated = circle
              updated.radius = dist
              update(updated)
            }
        )


    }
  }
}
