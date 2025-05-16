//
//  CanvasManager.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/3/25.
//

import SwiftUI
import Observation




@Observable
final class CanvasManager {
    
    
    let canvasSize: CGSize = CGSize(width: 5000, height: 5000)
   
    var gridSpacing: GridSpacing = .mm1
    
    var mouseLocation: CGPoint = .zero
    

    var enableSnapping: Bool = true
    var enableCrosshair: Bool = true
    var backgroundStyle: CanvasBackgroundStyle = .dotted
    var enableAxesBackground: Bool = true

    
    var showComponentDrawer: Bool = false
    
    
    var selectedLayoutTool: LayoutTool = .cursor
    var selectedSchematicTool: SchematicTool = .cursor
    

    func snap(_ point: CGPoint) -> CGPoint {
            guard enableSnapping else { return point }
        
           let step = gridSpacing.spacingPoints
           return CGPoint(
               x: round(point.x / step) * step,
               y: round(point.y / step) * step
           )
    }

    
    
    var canvasMousePosition: CGPoint {
            return snap(mouseLocation)
        }
    

    
    
}

