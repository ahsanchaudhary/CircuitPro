//
//  ContentView.swift
//  Circuit Pro
//
//  Created by Giorgi Tchelidze on 4/1/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
   
    var project: CircuitProjectModel
    var body: some View {
        VStack {
            Text("HELLO")
            Text(project.name)
          
        }
        .frame(width: 800, height: 600)
    }
    
    
}
//
//#Preview {
//    ContentView()
//        .modelContainer(
//            for: [
//                Project.self,
//                Design.self,
//                Schematic.self,
//                Layout.self,
//                Layer.self,
//                Net.self,
//                Via.self,
//                ComponentInstance.self,
//                SymbolInstance.self,
//                FootprintInstance.self,
//                Component.self,
//                Symbol.self,
//                Footprint.self,
//                Model.self
//            ],
//            inMemory: true
//        )
//    
//}
