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
    
    @State private var componentProperties: [ComponentProperty] = []
    
    
    enum ComponentDesignStage: String, CaseIterable, Identifiable {
        case component = "Component Data"
        case symbol = "Symbol Creation"
        case footprint = "Footprint Creation"
        
        var id: String { self.rawValue }
    }
    
    @State private var currentStage: ComponentDesignStage = .component
    
    var body: some View {
        VStack {
            stageIndicator
               
            Spacer()
             
        
    
                Group {
                    switch currentStage {
                    case .component:
                        componentDetails
                        
                    case .symbol:
                        SymbolDesignView()
                        
                    case .footprint:
                        Text("Hoe for shoes")
                        
                    }
                }
                .frame(width: 800, height: 500)
           
        
            Spacer()
            
        }
        .padding()
        .frame(minWidth: 800, minHeight: 600)
     


        .navigationTitle("Component Designer")
    }
    
    var stageIndicator: some View {
        HStack {
            ForEach(ComponentDesignStage.allCases) { stage in
                Text(stage.rawValue)
           
                    .padding(10)
                    .background(currentStage == stage ? .blue : .clear)
                    .foregroundStyle(currentStage == stage ? .white : .secondary)
                    .clipShape(.capsule)
                    .onTapGesture {
                        withAnimation {
                            currentStage = stage
                        }
                    }
                if stage == .component || stage == .symbol {
                    Image(systemName: "chevron.right")
                       
                        .foregroundStyle(.secondary)
                }
                
                
            }
        }
        .font(.headline)
        .padding()
    }
    
    
    var componentDetails: some View {
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
                Picker("", selection: $selectedCategory) {
                    Text("Select a Category").tag(nil as ComponentCategory?)
                    
                    ForEach(ComponentCategory.allCases) { category in
                        Text(category.label).tag(Optional(category))
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 300)
                
                
            }
            componentDesignSection("Properties") {
                ComponentPropertyView(componentProperties: $componentProperties)
            }
            
        }
        
    }
    
    var componentSymbol: some View {
        Text("Component Symbol")
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
    ComponentDesignView()
}
