//
//  ComponentPropertyView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/8/25.
//

import SwiftUI

struct ComponentPropertyView: View {
    
    @Binding var componentProperties: [ComponentProperty]
    
    @State private var selectedProperties: Set<ComponentProperty.ID> = []

    @State private var selectedValueType: PropertyValueType = .single
    
    var body: some View {
        VStack(spacing: 0) {
            Table($componentProperties, selection: $selectedProperties) {
                TableColumn("Property") { $property in
                    TextField("Name", text: $property.name)
                }
                TableColumn("Value") { $property in
                    HStack {
                        switch $property.value.wrappedValue {
                        case .single(let val):
                            TextField("Value", value: Binding(
                                get: { val ?? nil },
                                set: { newVal in
                                    $property.value.wrappedValue = .single(newVal)
                                }
                            ), format: .number)
                            
                        case .range(let minVal, let maxVal):
                            HStack {
                                TextField("Min", value: Binding(
                                    get: { minVal ?? nil },
                                    set: { newMin in
                                        $property.value.wrappedValue = .range(min: newMin, max: maxVal)
                                    }
                                ), format: .number)
                                
                                Text("-")
                                    .foregroundStyle(.secondary)
                                
                                TextField("Max", value: Binding(
                                    get: { maxVal ?? nil },
                                    set: { newMax in
                                        $property.value.wrappedValue = .range(min: minVal, max: newMax)
                                    }
                                ), format: .number)
                            }
                        }
                        
                        Menu {
                            ForEach(PropertyValueType.allCases) { type in
                                Button {
                                    let newValue: PropertyValue
                                    switch type {
                                    case .single:
                                        newValue = .single(nil)
                                    case .range:
                                        newValue = .range(min: nil, max: nil)
                                    }
                                    $property.value.wrappedValue = newValue
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
                
                TableColumn("Unit") { $property in
                    HStack {
                        Menu {
                            ForEach(SIPrefix.allCases, id: \.rawValue) { prefix in
                                Button {
                                    $property.unit.prefix.wrappedValue = prefix
                                } label: {
                                    Text(prefix.name)
                                }
                            }
                        } label: {
                            Text($property.unit.prefix.wrappedValue.symbol)
                        }
                        
                        Menu {
                            ForEach(BaseUnit.allCases, id: \.rawValue) { base in
                                Button {
                                    $property.unit.base.wrappedValue = base
                                } label: {
                                    Text(base.name)
                                }
                            }
                        } label: {
                            Text($property.unit.base.wrappedValue.symbol)
                        }
                    }
                }
                
                TableColumn("Warn on Edit") { $property in
                    Toggle("Warn on Edit", isOn: $property.warnsOnEdit)
                        .labelsHidden()
                }
                
            }
            .textFieldStyle(.roundedBorder)
            HStack {
       
                Button {
                    let newProperty = ComponentProperty(name: "", value: .single(nil), unit: .init(prefix: .none, base: .ohm))
                    componentProperties.append(newProperty)
                } label: {
                    Image(systemName: AppIcons.plus)
                }

                Button {
                    componentProperties.removeAll { property in
                        selectedProperties.contains(property.id)
                    }
                    selectedProperties.removeAll()
                } label: {
                    Image(systemName: AppIcons.minus)
                }
                .disabled(selectedProperties.isEmpty)

                Spacer()
            }
            .buttonStyle(.accessoryBar)
            .padding(10)
            .background(.quaternary)
            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.gray.opacity(0.3)), alignment: .top)
        }
       
      

        
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    ComponentPropertyView(componentProperties: .constant([ComponentProperty(name: "Capacitance", value: .single(10), unit: .init(prefix: .giga, base: .farad), warnsOnEdit: true)]))
}
