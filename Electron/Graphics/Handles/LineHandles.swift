//
//  LineHandles.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/22/25.
//
import SwiftUI



struct LineHandles: View {
    
    @Environment(\.canvasManager) private var canvasManager

    
  var line: LinePrimitive
  var update: (LinePrimitive) -> Void
  let size: CGFloat = 10

  var body: some View {
    ZStack {
      Circle()
        .fill(Color.white)
        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
        .frame(width: size, height: size)
        .position(line.start)
        .gesture(
          DragGesture()
            .onChanged { value in
              var updated = line
              updated.start = canvasManager.snap(value.location)
              update(updated)
            }
        )


      Circle()
        .fill(Color.white)
        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
        .frame(width: size, height: size)
        .position(line.end)
        .gesture(
          DragGesture()
            .onChanged { value in
              var updated = line
              updated.end = canvasManager.snap(value.location)
              update(updated)
            }
        )

    }
  }
}
