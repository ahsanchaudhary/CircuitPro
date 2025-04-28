//
//  ComponentDetailView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/28/25.
//

import SwiftUI

struct ComponentDetailView: View {
    

    @State private var componentName: String = ""
    
    @State private var selectedCategory: ComponentCategory?
    
    @State private var componentProperties: [ComponentProperty] = [ComponentProperty(key: nil, value: .single(nil), unit: .init())]

    var body: some View {
        VStack(alignment: .leading) {
            componentDesignSection("Component Name") {
                TextField("e.g. Resistor, Capacitor, LED", text: $componentName)
                    .textFieldStyle(.plain)
                    .font(.title3)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipAndStroke(with: .rect(cornerRadius: 7.5))
                
            }
            
            
            
            componentDesignSection("Category") {
                Picker("Category", selection: $selectedCategory) {
                    Text("Select a Category").tag(nil as ComponentCategory?)
                    
                    ForEach(ComponentCategory.allCases) { category in
                        Text(category.label).tag(Optional(category))
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .frame(width: 300)
                
            }
            componentDesignSection("Properties") {
                ComponentPropertiesView(componentProperties: $componentProperties)
            }
            
        }
    }
    
    func componentDesignSection<Content: View>(_ title: String? = nil, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            if let title {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fontWeight(.semibold)
                    .padding(5)
            }
            
            
            content()
        }
    }
}

#Preview {
    ComponentDetailView()
}
