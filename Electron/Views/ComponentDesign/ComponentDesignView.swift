//
//  ComponentDesignView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/17/25.
//

import SwiftUI

struct ComponentDesignView: View {    
    
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
                        ComponentDetailView()
                        
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
    
    

    
}

#Preview {
    ComponentDesignView()
}
