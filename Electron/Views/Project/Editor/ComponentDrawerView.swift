//
//  ComponentDrawerView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI

struct ComponentDrawerView: View {
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
             
                   
              
                Text("Local")
                Text("Hub")
                Spacer()
            }
            TextField("Search Components, Symbols, Footprints or 3D Models", text: $searchText)
                .textFieldStyle(.roundedBorder)

            Spacer()
            
        }
        .padding(10)
        .frame(height: 200)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(.ultraThinMaterial)
        
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .transition(.move(edge: .bottom))
        
    }
    
}

#Preview {
    ComponentDrawerView()
}
