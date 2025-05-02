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
  let size: CGFloat = 10
  

    private var handleOffset: CGSize {
      CGSize(width: circle.radius, height: 0)
    }


  var body: some View {

      Circle()
        .fill(Color.white)
        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
        .frame(width: size, height: size)
        .adjustedForMagnification(bounds: 1.0...5.0)
        .offset(handleOffset)
        .frame(width: 30, height: 30)


  
  }
}
