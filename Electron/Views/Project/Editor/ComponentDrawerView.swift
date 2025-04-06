//
//  ComponentDrawerView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI
import RealityKit

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
                .textFieldStyle(.plain)
                .padding(.vertical, 7.5)
                .padding(.horizontal, 10)
            
               
                .background(.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 7.5))
            

            Spacer()
            
        }
        .padding(10)
        .frame(height: 250)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(.ultraThinMaterial)
        
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .transition(.move(edge: .bottom).combined(with: .blurReplace))
        
        
    }
    
}

#Preview {
    ComponentDrawerView()
}
