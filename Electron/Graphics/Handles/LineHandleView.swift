//
//  LineHandles.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/22/25.
//
import SwiftUI



struct LineHandleView: View {
    
    
  var line: LinePrimitive
  let size: CGFloat = 10

  var body: some View {
    ZStack {
      Circle()
        .fill(Color.white)
        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
        .frame(width: size, height: size)
        .adjustedForMagnification(bounds: 1.0...5.0)
        .position(line.start)


      Circle()
        .fill(Color.white)
        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
        .frame(width: size, height: size)
        .adjustedForMagnification(bounds: 1.0...5.0)
        .position(line.end)

    }

  }
}
