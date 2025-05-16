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
    
    var magnification: CGFloat = 1
    var gridSpacing: GridSpacing = .mm1
    
    var mouseLocation: CGPoint = .zero
    

    var enableSnapping: Bool = true
    var enableCrosshair: Bool = true
    var backgroundStyle: CanvasBackgroundStyle = .dotted
    var enableAxesBackground: Bool = true
    
    var showComponentDrawer: Bool = false


    
    
}

