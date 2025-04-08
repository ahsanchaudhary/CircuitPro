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
    let gridSpacing: CGFloat = 20.0
    
    var zoom: CGFloat = 1.0
    
    var enableSnapping: Bool = true
    var enableCrosshair: Bool = true
    var backgroundStyle: BackgroundStyle = .dotted
    

    
   var showComponentDrawer: Bool = true
    



    
    
    
}

