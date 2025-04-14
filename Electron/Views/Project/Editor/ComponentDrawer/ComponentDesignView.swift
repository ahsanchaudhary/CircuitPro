//
//  ComponentDesignView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/8/25.
//

import SwiftUI

struct ComponentDesignView: View {
    //Modifications in this view should create a component instance instead of modifying the original content.
    
    let component: Component
    
    @State private var componentName: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 200, height: 200)
                    .foregroundColor(.gray)
            
                VStack(alignment: .leading) {
                    TextField(component.name, text: $componentName)
                        .font(.headline)
                        .textFieldStyle(.plain)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
           
                    componentPropertyView
                    
                    
                }
                
             
                  
                
            }
            Spacer()
        }
        .padding()
    }
    
    var componentPropertyView: some View {
        VStack(alignment: .leading) { 
            Text("Component Properties")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fontWeight(.semibold)
                .padding(5)
//        Table(component.properties) {
////            TableColumn("Property") { property in
////                           Text(property.name)
////                       }
////            TableColumn("Value") { property in
////                Text(property.value.description)
////                       }
////            TableColumn("Unit") { (property: ComponentProperty) in
////                
////                HStack {
////                    Menu {
////                        ForEach(SIPrefix.allCases, id: \.rawValue) { prefix in
////                            Text(prefix.rawValue)
////                        }
////                    } label: {
////                        Text(property.unit?.prefix.rawValue ?? SIPrefix.giga.rawValue)
////                    }
////                    
////                    Menu {
////                        ForEach(BaseUnit.allCases, id: \.rawValue) { prefix in
////                            Text(prefix.rawValue)
////                        }
////                    } label: {
////                        Text(property.unit?.base.rawValue ?? SIPrefix.giga.rawValue)
////                    }
////                }
////                
////            }
//            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    ComponentDesignView(component: Component(name: "Test", symbol: Symbol(name: "Test")))
}
