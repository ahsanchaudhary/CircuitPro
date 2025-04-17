//
//  ComponentPropertyView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/8/25.
//

import SwiftUI

struct ComponentPropertyView: View {
    
    @Binding var componentProperties: [ComponentProperty]
    
    var body: some View {

        Table($componentProperties) {
            TableColumn("Property") { $property in
                TextField("Name", text: $property.name)
            }
            TableColumn("Value") { $property in
                switch $property.value.wrappedValue {
                case .single(let val):
                    TextField("Value", value: Binding(
                        get: { val },
                        set: { newVal in
                            $property.value.wrappedValue = .single(newVal)
                        }
                    ), format: .number)
                
                    
                case .range(let minVal, let maxVal):
                    HStack {
                        TextField("Min", value: Binding(
                            get: { minVal },
                            set: { newMin in
                                $property.value.wrappedValue = .range(min: newMin, max: maxVal)
                            }
                        ), format: .number)
                      
                        
                        Text("-")
                            .foregroundStyle(.secondary)

                        TextField("Max", value: Binding(
                            get: { maxVal },
                            set: { newMax in
                                $property.value.wrappedValue = .range(min: minVal, max: newMax)
                            }
                        ), format: .number)
           
                    }
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
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    ComponentPropertyView(componentProperties: .constant([ComponentProperty(name: "Capacitance", value: .single(10), unit: .init(prefix: .giga, base: .farad), warnsOnEdit: true)]))
}
