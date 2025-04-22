//
//  Line.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/12/25.
//

import SwiftUI

struct LinePrimitive: GraphicPrimitive {
    var id = UUID()
  
    var strokeWidth: CGFloat
    var color: SDColor
    var filled: Bool = false 

    var start: CGPoint
    var end: CGPoint
    
    var position: CGPoint {
         get {
             CGPoint(x: (start.x + end.x) / 2, y: (start.y + end.y) / 2)
         }
         set {
             // Calculate the vector needed to move the current midpoint to the new position (newValue)
             let currentMidpoint = CGPoint(x: (start.x + end.x) / 2, y: (start.y + end.y) / 2)
             let dx = newValue.x - currentMidpoint.x
             let dy = newValue.y - currentMidpoint.y

             // Apply this vector to both start and end points to translate the line
             start = CGPoint(x: start.x + dx, y: start.y + dy)
             end = CGPoint(x: end.x + dx, y: end.y + dy)
         }
     }
}
