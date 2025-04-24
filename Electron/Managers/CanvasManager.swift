//
//  CanvasManager.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/3/25.
//

import SwiftUI
import Observation

enum GridSpacing: CGFloat, CaseIterable, Identifiable {
  case mm5    = 5.0
  case mm2_5  = 2.5
  case mm1    = 1.0
  case mm0_5  = 0.5
  case mm0_25 = 0.25
  case mm0_1  = 0.1

  var id: Self { self }

  /// For showing in a Picker or menu
  var title: String {
    switch self {
    case .mm5:    return "5 mm"
    case .mm2_5:  return "2.5 mm"
    case .mm1:    return "1 mm"
    case .mm0_5:  return "0.5 mm"
    case .mm0_25: return "0.25 mm"
    case .mm0_1:  return "0.1 mm"
    }
  }

  /// Convert mm to screen points given your scale (pts per mm)
    var spacingPoints: CGFloat {
        rawValue * 4
  }
}


@Observable
final class CanvasManager {
    
    
    let canvasSize: CGSize = CGSize(width: 5000, height: 5000)
   
    var gridSpacing: GridSpacing = .mm1
    
    var mouseLocation: CGPoint = .zero
    

    var enableSnapping: Bool = true
    var enableCrosshair: Bool = true
    var backgroundStyle: BackgroundStyle = .dotted
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

