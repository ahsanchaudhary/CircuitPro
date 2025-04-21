//
//  UnitColumn.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/21/25.
//



import SwiftUI

struct UnitColumn: View {
    @Binding var property: ComponentProperty
    
    var body: some View {
        HStack {
            Menu {
                ForEach(SIPrefix.allCases, id: \.rawValue) { prefix in
                    Button {
                        property.unit.prefix = prefix
                    } label: {
                        Text(prefix.name)
                    }
                }
            } label: {
                Text(property.unit.prefix.symbol)
            }
            
            Menu {
                ForEach(BaseUnit.allCases, id: \.rawValue) { base in
                    Button {
                        property.unit.base = base
                    } label: {
                        Text(base.name)
                    }
                }
            } label: {
                Text(property.unit.base.symbol)
            }
        }
    }
}

