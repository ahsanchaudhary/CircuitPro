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
    
    
    let canvasSize: CGSize = CGSize(width: 3000, height: 3000)
   
    var gridSpacing: CGFloat = 10.0
    
    var mouseLocation: CGPoint = .zero
    

    var enableSnapping: Bool = true
    var enableCrosshair: Bool = true
    var backgroundStyle: BackgroundStyle = .dotted
    var enableAxesBackground: Bool = true

    
    var showComponentDrawer: Bool = false
    
    
    var selectedLayoutTool: LayoutTool = .cursor
    var selectedSchematicTool: SchematicTool = .cursor
    

    func snap(point: CGPoint) -> CGPoint {
            return CGPoint(
                x: round(point.x / gridSpacing) * gridSpacing,
                y: round(point.y / gridSpacing) * gridSpacing
            )
        }

    
    var canvasMousePosition: CGPoint {
            return enableSnapping ? snap(point: mouseLocation) : mouseLocation
        }
    

    
    
}

