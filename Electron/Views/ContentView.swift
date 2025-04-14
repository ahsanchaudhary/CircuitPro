//
//  ContentView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/1/25.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.projectManager) private var projectManager
    @Environment(\.modelContext) private var modelContext
    @Query private var projects: [Project]
    
    @State private var path = NavigationPath()

    // Adaptive grid: automatically fills columns based on available width
    private let columns = [
        GridItem(.adaptive(minimum: 200)) // Adjust 150 to your preferred minimum width
    ]

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(projects) { project in
                        projectView(project)
                            
                            .onTapGesture {
                                projectManager.project = project
                                projectManager.selectedDesign = project.designs.first
                                path.append(project)
                            }
                            .contextMenu {
                                Button {
                                    modelContext.delete(project)
                                } label: {
                                    Text("Delete Project")
                                }

                            }
                            .padding()
                    
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: AppIcons.plus)
                    }
                }
            }
            
            .navigationDestination(for: Project.self) { project in
                           
                ProjectView(project: project)
                          
            }
        }
   
      
     
    }
    private func projectView(_ project: Project) -> some View {
        VStack(alignment: .leading) {
            
            Text(project.name)
                .font(.headline)
            Text(project.timestamps.dateCreated, format: Date.FormatStyle(date: .numeric, time: .standard))
                .font(.subheadline)
                .foregroundColor(.secondary)
       
        }
        .padding()
        .frame(width: 200, height: 150, alignment: .topLeading)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(.gray.opacity(0.2), lineWidth: 1)
        }
    }

    private func addItem() {
        withAnimation {
            // Create the project with an empty list of designs.
            let project = Project(name: "Project \(projects.count + 1)", designs: [])
            
            // Create schematic and layout without design assignment.
            let schematic = Schematic(title: "Schematic 1", data: Data(), design: nil)
            let layout = Layout(title: "Default Layout", data: Data(), design: nil)
            
            // Populate default layers for the layout.
            layout.populateDefaultLayers()
            
            // Create the design instance.
            // (At this point, schematic and layout are passed as-is.
            //  Their 'design' properties will be set after the design is instantiated.)
            let design = Design(name: "Design 1", schematic: schematic, layout: layout, project: project)
            
            // Now wire up the references from schematic and layout back to the design.
            schematic.design = design
            layout.design = design
            
            // Add design to project's designs array.
            project.designs.append(design)
            
            // Create a test net and associate it with the schematic.
            let testNet = Net(name: "Test Net", schematic: schematic, color: SDColor(color: .red))
            schematic.nets.append(testNet)
            
            // Insert the project into your model context.
            modelContext.insert(project)
        }
    }

    
    
    
}

#Preview {
    ContentView()
        .modelContainer(
                       for: [
                           Project.self,
                           Schematic.self,
                           Layout.self,
                           Layer.self,
                           Net.self,
                           Via.self,
                           ComponentInstance.self,
                           SymbolInstance.self,
                           FootprintInstance.self,
                           Component.self,
                           Symbol.self,
                           Footprint.self,
                           Model.self
                       ],
                       inMemory: true
                   )
       
}
