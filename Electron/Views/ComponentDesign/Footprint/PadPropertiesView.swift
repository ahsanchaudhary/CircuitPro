//
//  PadPropertiesView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/7/25.
//

import SwiftUI

struct PadPropertiesView: View {
    
    @Binding var pad: Pad
    
    var body: some View {
        Group {
            IntegerField(title: "Number", value: $pad.number)
            
            Picker("Pad Type", selection: $pad.type) {
                ForEach(PadType.allCases) { padType in
                    Text(padType.label).tag(padType)
                }
            }
            if pad.type == .throughHole {
                DoubleField(
                    title: "Drill Diameter",
                    value: Binding(
                        get: { pad.drillDiameter ?? 0.0 },
                        set: { pad.drillDiameter = $0 }
                    )
                )
            }

            Picker("Shape", selection: Binding(
                get: {
                    pad.isCircle ? "Circle" : "Rectangle"
                },
                set: { newShape in
                    if newShape == "Circle" {
                        pad.shape = .circle(radius: 5)
                    } else {
                        pad.shape = .rect(width: 5, height: 10)
                    }
                }
            )) {
                Text("Circle").tag("Circle")
                Text("Rectangle").tag("Rectangle")
            }

            if pad.isCircle {
                DoubleField(title: "Radius", value: $pad.radius)
            } else {
                DoubleField(title: "Width", value: $pad.width)
                DoubleField(title: "Height", value: $pad.height)
            }
        }
    }
}


