//
//  PropertyColumn.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/21/25.
//

import SwiftUI

struct PropertyColumn: View {
    @Binding var property: ComponentProperty

    var body: some View {
        Menu {
            // Basic Types
            ForEach(PropertyKey.BasicType.allCases, id: \.self) { basic in
                Button {
                    property.key = .basic(basic)
                } label: {
                    Text(basic.label)
                }
            }
            Divider()

            // Nested Menus
            Menu("Rating") {
                ForEach(PropertyKey.RatingType.allCases, id: \.self) { type in
                    Button {
                        property.key = .rating(type)
                    } label: {
                        Text(type.label)
                    }
                }
            }

            Menu("Temperature") {
                ForEach(PropertyKey.TemperatureType.allCases, id: \.self) { type in
                    Button {
                        property.key = .temperature(type)
                    } label: {
                        Text(type.label)
                    }
                }
            }

            Menu("RF") {
                ForEach(PropertyKey.RFType.allCases, id: \.self) { type in
                    Button {
                        property.key = .rf(type)
                    } label: {
                        Text(type.label)
                    }
                }
            }

            Menu("Battery") {
                ForEach(PropertyKey.BatteryType.allCases, id: \.self) { type in
                    Button {
                        property.key = .battery(type)
                    } label: {
                        Text(type.label)
                    }
                }
            }

            Menu("Sensor") {
                ForEach(PropertyKey.SensorType.allCases, id: \.self) { type in
                    Button {
                        property.key = .sensor(type)
                    } label: {
                        Text(type.label)
                    }
                }
            }

        } label: {
            Text(property.key?.label ?? "Select a Property")
        }
    }
}
