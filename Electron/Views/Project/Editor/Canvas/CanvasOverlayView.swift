//
//  CanvasOverlayView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/11/25.
//

import SwiftUI

struct CanvasOverlayView: View {
    
    @Environment(\.canvasManager) private var canvasManager
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                SchematicToolbarView()
            }
            Spacer()
            HStack {
                ZoomControlView()
                
                Spacer()
                ComponentDrawerButton()
                
                
                Spacer()
                CanvasControlView()
                
            }
            Group {
                if canvasManager.showComponentDrawer {
                    ComponentDrawerView()
                    
                }
            }
            
        }
        
    }

}

#Preview {
    CanvasOverlayView()
}
