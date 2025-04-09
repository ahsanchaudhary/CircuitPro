//
//  CanvasManager.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/3/25.
//

import SwiftUI
import Observation

extension CGPoint {
    static func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
    }
}


@Observable
final class CanvasManager {
    
    
    let canvasSize: CGSize = CGSize(width: 3000, height: 3000)
    let unitSpacing: CGFloat = 10.0
    
    var mouseLocation: CGPoint = .zero
    
    var zoom: CGFloat = 1.0
    
    var enableSnapping: Bool = true
    var enableCrosshair: Bool = true
    var backgroundStyle: BackgroundStyle = .dotted
    

    
   var showComponentDrawer: Bool = false
    
    
    var selectedLayoutTool: LayoutTools = .cursor
    

    func snap(point: CGPoint) -> CGPoint {
            return CGPoint(
                x: round(point.x / unitSpacing) * unitSpacing,
                y: round(point.y / unitSpacing) * unitSpacing
            )
        }
    
    var canvasMousePosition: CGPoint {
            return enableSnapping ? snap(point: mouseLocation) : mouseLocation
        }
    
    var transformedMousePosition: CGPoint {
        return canvasMousePosition * zoom
    }

    
    
    
}

