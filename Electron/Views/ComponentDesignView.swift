//
//  ComponentDesignView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/17/25.
//

import SwiftUI

struct ComponentDesignView: View {
    
    @State private var componentName: String = ""
    @State private var selectedCategory: ComponentCategory?
    
    var body: some View {
        VStack {
            componentDetails
   
        }
        .navigationTitle("Component Designer")
    }
    
    
    var componentDetails: some View {
        VStack {
            TextField("", text: $componentName)
            Picker("Select category", selection: $selectedCategory) {
                ForEach(ComponentCategory.allCases) { category in
                    Text(category.label).tag(category)
                  
                }
            }
            .pickerStyle(.menu)
            Text("Component Property Table View")
        }

    }
    
    var componentSymbol: some View {
        Text("Component Symbol")
    }
}

#Preview {
    ComponentDesignView()
}
