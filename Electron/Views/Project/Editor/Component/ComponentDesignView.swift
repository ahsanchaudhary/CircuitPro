//
//  ComponentDesignView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/8/25.
//

import SwiftUI

struct ComponentDesignView: View {
    //Modifications in this view should create a component instance instead of modifying the original content.
    
    let component: ComponentItem
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 200, height: 200)
                    .foregroundColor(.gray)
            
                VStack(alignment: .leading) {
                    Text(component.name)
                        .font(.headline)
                        .padding()
                    componentPropertyView
                }
             
                  
                
            }
            Spacer()
        }
        .padding()
    }
    
    var componentPropertyView: some View {
        Table(component.properties) {
            TableColumn("Property Name") { property in
                           Text(property.name)
                       }
            TableColumn("Value") { property in
                Text(property.value.description)
                       }
            TableColumn("Unit") { property in
                            // If a unit exists, display its description; otherwise display "N/A"
                            Text(property.unit?.description ?? "N/A")
                        }
        }
    }
}

#Preview {
    ComponentDesignView(component: ComponentItem(name: "Test", symbol: SymbolItem(name: "Test")))
}
