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
        GridItem(.adaptive(minimum: 150)) // Adjust 150 to your preferred minimum width
    ]

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(projects) { project in
                       
                            VStack(alignment: .leading) {
                                Text("Project")
                                    .font(.headline)
                                Text(project.timestamps.dateCreated, format: Date.FormatStyle(date: .numeric, time: .standard))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
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
            .navigationDestination(for: Project.self) { project in
                           
                ProjectView(project: project)
                          
                       }
        }
      
        .toolbar {
            ToolbarItem {
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Project(name: "Project 1")
            modelContext.insert(newItem)
        }
    }
    
    
    
}

#Preview {
    ContentView()
        .modelContainer(for: Project.self, inMemory: true)
}
