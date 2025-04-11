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
                            Button {
                                withAnimation {
                                    canvasManager.showComponentDrawer.toggle()
                                }
                              
                            } label: {
                                HStack {
                                    if !canvasManager.showComponentDrawer {
                                        Image(systemName: AppIcons.trayFull)
                                            .transaction { transaction in
                                                transaction.animation = nil
                                            
                                            }
                                
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
                            .clipShape(Capsule())
                      

                            Spacer()
                            CanvasControlView()
                            
                        }
                        if canvasManager.showComponentDrawer {
                            ComponentDrawerView()
                        }
                  
                    }

    }
}

#Preview {
    CanvasOverlayView()
}
