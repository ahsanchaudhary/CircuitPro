//
//  ZoomControlView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/2/25.
//

import SwiftUI

struct ZoomControlView: View {

    @Environment(\.canvasManager) var canvasManager
    
 

    let zoomSteps: [CGFloat] = [0.5, 0.75, 1, 1.25, 1.5, 2.0]

    var clampedZoomText: String {
        let clamped = max(0.5, min(canvasManager.zoom, 2.0))
        return "\(Int(clamped * 100))%"
    }

    
    var body: some View {
        HStack {
            Button {
                if let currentIndex = zoomSteps.firstIndex(where: { $0 >= canvasManager.zoom }),
                   currentIndex > 0 {
                    canvasManager.zoom = zoomSteps[currentIndex - 1]
                }
            } label: {
                Image(systemName: AppIcons.minus)
                    .background(
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 30, height: 30)
                            )
                            .contentShape(Rectangle())
            }
        

            Divider()
                .frame(height: 10)
            
            Menu {
                ForEach(zoomSteps, id: \.self) { step in
                    Button {
                        canvasManager.zoom = step
                    } label: {
                        Text("\(Int(step * 100))%")
                    }
                }
            } label: {
                HStack {
                    Text(clampedZoomText)

                    Image(systemName: AppIcons.chevronDown)
                        .imageScale(.small)
                }
           
            }
    

            Divider()
                .frame(height: 10)

            Button {
                if let currentIndex = zoomSteps.firstIndex(where: { $0 > canvasManager.zoom }),
                   currentIndex < zoomSteps.count {
                    canvasManager.zoom = zoomSteps[currentIndex]
                }
            } label: {
                Image(systemName: AppIcons.plus)
            }
        }
        .buttonStyle(.plain)
        
        .font(.callout)
        .fontWeight(.semibold)
        .directionalPadding(vertical: 7.5, horizontal: 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
}

