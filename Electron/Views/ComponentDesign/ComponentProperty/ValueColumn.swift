//
//  ValueColumn.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/21/25.
//



import SwiftUI

struct ValueColumn: View {
    @Binding var property: ComponentProperty
    
    var body: some View {
        HStack {
            switch property.value {
            case .single(let val):
                TextField("Value", value: Binding(
                    get: { val },
                    set: { newVal in
                        property.value = .single(newVal)
                    }
                ), format: .number)

            case .range(let minVal, let maxVal):
                HStack {
                    TextField("Min", value: Binding(
                        get: { minVal },
                        set: { newMin in
                            property.value = .range(min: newMin, max: maxVal)
                        }
                    ), format: .number)

                    Text("-")
                        .foregroundStyle(.secondary)

                    TextField("Max", value: Binding(
                        get: { maxVal },
                        set: { newMax in
                            property.value = .range(min: minVal, max: newMax)
                        }
                    ), format: .number)
                }
            }

            Menu {
                ForEach(PropertyValueType.allCases) { type in
                    Button {
                        switch type {
                        case .single:
                            property.value = .single(nil)
                        case .range:
                            property.value = .range(min: nil, max: nil)
                        }
                    } label: {
                        Text(type.label)
                    }
                }
            } label: {
                Image(systemName: AppIcons.gear)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
    }
}
