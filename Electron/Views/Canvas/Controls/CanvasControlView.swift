//
//  CanvasControlView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/3/25.
//
import SwiftUI

struct CanvasControlView: View {
    
@Environment(\.canvasManager) var canvasManager
    

    
    
    var body: some View {
        HStack {
            Button {
                canvasManager.enableCrosshair.toggle()
            } label: {
                Image(systemName: "dot.scope")
                    .foregroundStyle(canvasManager.enableCrosshair ? .blue : .secondary)
            }
            Divider()
                .frame(height: 20)
            
            Button {
                canvasManager.enableSnapping.toggle()
            } label: {
                Image(systemName: "dot.squareshape.split.2x2")
         
                    .foregroundStyle(canvasManager.enableSnapping ? .blue : .secondary)
            }

                            Divider()
                                .frame(height: 20)
                            Menu {
                                
                                Button {
                                    canvasManager.backgroundStyle = .dotted
                                } label: {
                                    Label("Dotted Background", systemImage: canvasManager.backgroundStyle == .dotted ? "checkmark.circle.fill" :"squareshape.dotted.split.2x2")
                                        .labelStyle(.titleAndIcon)
                                }
                                Button {
                                    canvasManager.backgroundStyle = .grid
                                } label: {
                                    Label("Grid Background", systemImage: canvasManager.backgroundStyle == .grid ? "checkmark.circle.fill" : "grid")
                                        .labelStyle(.titleAndIcon)
                                }
                            } label: {
                                Image(systemName: "viewfinder.rectangular")
                            }
                            
                        }
                        .buttonStyle(.plain)
                        .padding(5)
                        .padding(.horizontal, 7.5)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())

        
    }
}
