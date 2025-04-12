//
//  ComponentDrawerView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI
import RealityKit

struct ComponentDrawerView: View {
    
    enum LibraryType: String, CaseIterable {
        case project = "Project Library"
        case app = "App Library"
        case hub = "Hub"
    }
    
    @State private var selectedLibraryType: LibraryType = .project
      
    
    @State private var components: [ComponentItem] = []
    
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                TextField("Search Components", text: $searchText)
                    .textFieldStyle(.plain)
                    .directionalPadding(vertical: 7.5, horizontal: 10)
                
                
                    .background(.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
//                Text("Symbols")
//                Text("Footprints")
//                Text("3D Models")
            }
            HStack {
                ForEach(LibraryType.allCases, id: \.self) { libraryType in
                    Button {
                        withAnimation {
                            selectedLibraryType = libraryType
                        }

                       
                    } label: {
                        Text(libraryType.rawValue)
                         
                            
                    }
                    .buttonStyle(.plain)
                    .directionalPadding(vertical: 5, horizontal: 7.5)
                    .background(selectedLibraryType == libraryType ? .gray.opacity(0.2) : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 5))

                 
                    if libraryType == .project {
                        Divider()
                            .frame(height: 15)
                    }
                 
                }
            }
            .font(.subheadline)
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 150, maximum: 200)), count: 3), alignment: .leading) {
                    ForEach(components) { component in
                        ComponentView(component: component)
                           
                    }
                }
              
            }
    
          
         
            
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
