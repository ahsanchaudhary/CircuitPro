//
//  CanvasControlView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/3/25.
//
import SwiftUI

struct CanvasControlView: View {
    

    
    @Binding var enableCrosshair: Bool
    @Binding var backgroundStyle: BackgroundStyle
    
    
    var body: some View {
        HStack {
                            Button {
                                enableCrosshair.toggle()
                            } label: {
                                Image(systemName: "dot.scope")
                                    .foregroundStyle(enableCrosshair ? .blue : .secondary)
                            }
                            Divider()
                                .frame(height: 20)
                            Menu {
                                
                                Button {
                                    backgroundStyle = .dotted
                                } label: {
                                    Label("Dotted Background", systemImage: backgroundStyle == .dotted ? "checkmark.circle.fill" :"squareshape.dotted.split.2x2")
                                        .labelStyle(.titleAndIcon)
                                }
                                Button {
                                    backgroundStyle = .grid
                                } label: {
                                    Label("Grid Background", systemImage: backgroundStyle == .grid ? "checkmark.circle.fill" : "grid")
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
