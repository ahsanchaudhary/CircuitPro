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
    var backgroundStyle: BackgroundStyle = .dotted
    
    var zoomLevel: CGFloat = 1.0  // Added zoom level here for centralized management.

    
    var crosshairPosition: CGPoint = .zero

    
    
    
}

