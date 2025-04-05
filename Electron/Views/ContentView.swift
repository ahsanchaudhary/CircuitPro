//
//  ContentView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/1/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
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
                        Label("Add Item", systemImage: "plus")
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
                let project = Project(name: "Project \(projects.count + 1)")
                let schematic = Schematic(title: "Schematic 1", data: Data(), project: project)
                let layout = Layout(title: "Default Layout", data: Data(), project: project)
                layout.populateDefaultLayers()
                project.layout = layout
                project.schematic = schematic
                
                let testNet = Net(name: "Test Net", schematic: schematic, color: ColorEntity(color: .red))
                schematic.nets.append(testNet)

                modelContext.insert(project)
            }
    }
    
    
    
}

#Preview {
    ContentView()
        .modelContainer(for: [Project.self, Schematic.self, Layout.self, PCBLayer.self, Net.self], inMemory: true)
}
