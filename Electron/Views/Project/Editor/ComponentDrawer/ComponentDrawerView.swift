//
//  ComponentDrawerView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI
import RealityKit
import SwiftData

struct ComponentDrawerView: View {
    
    enum LibraryType: String, CaseIterable {
        case project = "Project Library"
        case app = "App Library"
        case user = "User Library"
        case hub = "Hub"
    }
    
    @State private var selectedLibraryType: LibraryType = .project
      
    @Environment(\.canvasManager) private var canvasManager
    @Environment(\.projectManager) private var projectManager
    @Environment(\.modelContext) private var modelContext
    @Query private var components: [Component]
    @Query private var componentInstances: [ComponentInstance]
    

    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            
      
           librarySelector
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 150, maximum: 200)), count: 3), alignment: .leading) {
                    
                    switch selectedLibraryType {
                    case .project:
                        ForEach(projectManager.activeComponentInstances) { instance in
                            VStack {
                                Text(components.first(where: { $0.uuid == instance.componentUUID})?.name  ?? "")
                                Text("\(instance.symbolInstance.uuid)")
                                Text("\(instance.properties)")
                            }
                               
                        }
                    case .app:
                        ForEach(components) { component in
                            ComponentView(component: component)
                               
                        }
            
                    default:
                        Text("Library")
                    }
                   
                }
                .transaction { transaction in
                    transaction.animation = nil
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
    
    var librarySearchField: some View {
                    HStack {
                        TextField("Search Components", text: $searchText)
                            .textFieldStyle(.plain)
                            .directionalPadding(vertical: 7.5, horizontal: 10)
        
        
                            .background(.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    }
    }
    
    var librarySelector: some View {
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
    }
    
  
    
   
    
}

#Preview {
    ComponentDrawerView()
}
