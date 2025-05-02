//
//  ComponentDetailView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/28/25.
//

import SwiftUI

struct ComponentDetailView: View {
    
    @Environment(\.componentDesignManager) private var componentDesignManager
    

  

    var body: some View {
        @Bindable var manager = componentDesignManager
        VStack(alignment: .leading) {
            HStack {
                componentDesignSection("Component Name") {
                    TextField("e.g. Light Emitting Diode", text: $manager.componentName)
                        .textFieldStyle(.plain)
                        .font(.title3)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipAndStroke(with: .rect(cornerRadius: 7.5))
                    
                }
                componentDesignSection("Abbreviation") {
                    TextField("e.g. LED", text: $manager.componentAbbreviation)
                        .textFieldStyle(.plain)
                        .font(.title3)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipAndStroke(with: .rect(cornerRadius: 7.5))
                        .frame(width: 200)
                    
                }
            }
            
            
            
            componentDesignSection("Category") {
                Picker("Category", selection: $manager.selectedCategory) {
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
                ComponentPropertiesView(componentProperties: $manager.componentProperties)
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
