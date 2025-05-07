//
//  ContentView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/1/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.appManager) private var appManager
    @Environment(\.projectManager) private var projectManager
    @Environment(\.modelContext) private var modelContext
    
    @Query private var projects: [Project]
    
    private let columns = [
        GridItem(.adaptive(minimum: 200))
    ]
    
    var body: some View {
        @Bindable var bindableAppManager = appManager
        
        NavigationStack(path: $bindableAppManager.path) {
            
            projectList
            
                .padding()
                .toolbar {
                    ToolbarItem {
                        Button(action: addProject) {
                            Label("Add Project", systemImage: AppIcons.plus)
                        }
                    }
                    ToolbarItem {
                        Button {
                            appManager.path.append(ElectronPage.componentDesign)
                        } label: {
                            Text("Create a component")
                        }
                    }
                }
                .navigationDestination(for: ElectronPage.self) { page in
                    switch page {
                    case .project(let project):
                        ProjectView(project: project)
                    case .componentDesign:
                        ComponentDesignView()
                    }
                }
            
        }
    }
    
    
    private var projectList: some View {
        ScrollView {
            
            LazyVGrid(columns: columns) {
                ForEach(projects) { project in
                    projectCard(project)
                    
                        .onTapGesture {
                            projectManager.project = project
                            projectManager.selectedDesign = project.designs.first
                            appManager.path.append(ElectronPage.project(project))
                        }
                        .contextMenu {
                            Button {
                                modelContext.delete(project)
                            } label: {
                                Label("Delete Project", systemImage: AppIcons.trash)
                            }
                            
                        }
                    
                    
                }
            }
            
        }
    }
    private func projectCard(_ project: Project) -> some View {
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
    
    private func addProject() {
        withAnimation {
            // 1) Create the Project
            let project = Project(name: "Project \(projects.count + 1)", designs: [])
            
            // 2) Create an empty Design (no schematic/layout yet)
            let design = Design(
                name: "Design 1",
                schematic: nil,     // will wire up in a moment
                layout:    nil,
                project:   project
            )
            
            // 3) Create Schematic & Layout pointing back at that Design
            let schematic = Schematic(title: "Schematic 1", design: design)
            let layout    = Layout(title: "Default Layout", design: design)
            
            // 4) Populate default layers on the layout
            layout.populateDefaultLayers()
            
            // 5) Wire the Design → Schematic/Layout links
            design.schematic = schematic
            design.layout    = layout
            
            // 6) Add the Design into the Project
            project.designs.append(design)
            
            // 7) Create a sample Net on the Schematic
            let testNet = Net(
                name: "Test Net",
                schematic: schematic,
                color: SDColor(color: .red)
            )
            schematic.nets.append(testNet)
            
            // 8) Insert the Project (cascades to designs, schematic, layout, nets…)
            modelContext.insert(project)
        }
    }
    
    
    
}

#Preview {
    ContentView()
        .modelContainer(
            for: [
                Project.self,
                Design.self,
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
