//
//  ZoomControlView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/2/25.
//

import SwiftUI

struct ZoomControlView: View {

    
    @Binding var zoom: CGFloat

    let zoomSteps: [CGFloat] = [0.5, 0.75, 1, 1.25, 1.5, 2.0]

    var clampedZoomText: String {
        let clamped = max(0.5, min(zoom, 2.0))
        return "\(Int(clamped * 100))%"
    }

    
    var body: some View {
        HStack {
            Button {
                if let currentIndex = zoomSteps.firstIndex(where: { $0 >= zoom }),
                   currentIndex > 0 {
                    zoom = zoomSteps[currentIndex - 1]
                }
            } label: {
                Image(systemName: "minus")
                    .background(
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 30, height: 30)
                            )
                            .contentShape(Rectangle())
            }
        

            Divider()
                .frame(height: 20)
            
            Menu {
                ForEach(zoomSteps, id: \.self) { step in
                    Button {
                        zoom = step
                    } label: {
                        Text("\(Int(step * 100))%")
                    }
                }
            } label: {
                HStack {
                    Text(clampedZoomText)

                    Image(systemName: "chevron.down")
                        .imageScale(.small)
                }
           
            }
    

            Divider()
                .frame(height: 20)

            Button {
                if let currentIndex = zoomSteps.firstIndex(where: { $0 > zoom }),
                   currentIndex < zoomSteps.count {
                    zoom = zoomSteps[currentIndex]
                }
            } label: {
                Image(systemName: "plus")
            }
        }
        .buttonStyle(.plain)
        
        .padding(5)
        .padding(.horizontal, 7.5)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
}

