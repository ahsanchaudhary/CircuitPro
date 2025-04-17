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
                componentDrawerButton
                
                
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
    
    var componentDrawerButton: some View {
        Button {
            withAnimation {
                canvasManager.showComponentDrawer.toggle()
            }
            
        } label: {
            HStack {
                if !canvasManager.showComponentDrawer {
                    Image(systemName: AppIcons.trayFull)
                     
                    
                }
                Text("Component Drawer")
                
                if canvasManager.showComponentDrawer {
                    Image(systemName: AppIcons.xmark)
         
                }
            }
            
            
            
        }
        
        .buttonStyle(.plain)
        .font(.callout)
        .fontWeight(.semibold)
        .directionalPadding(vertical: 7.5, horizontal: 10)
        .background(.ultraThinMaterial)
        .clipAndStroke(with: .capsule, strokeColor: .gray.opacity(0.3), lineWidth: 1)
        
        
        
    }
}

#Preview {
    CanvasOverlayView()
}
