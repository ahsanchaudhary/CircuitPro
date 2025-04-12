//
//  ElectronApp.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/1/25.
//

import SwiftUI
import SwiftData

@main
struct ElectronApp: App {
    @State var canvasManager = CanvasManager()
    @State var projectManager = ProjectManager()
    @State var scrollViewManager = ScrollViewManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Project.self,
            Schematic.self,
            Layout.self,
            Layer.self,
            Net.self,
            Via.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, minHeight: 600)
        }
        
        .modelContainer(sharedModelContainer)
        .environment(\.canvasManager, canvasManager)
        .environment(\.projectManager, projectManager)
        .environment(\.scrollViewManager, scrollViewManager)

        WindowGroup(id: "SecondWindow") {
            SettingsView()
                .frame(minWidth: 800, minHeight: 600)
            
        }
        .windowStyle(.automatic)
        .windowToolbarStyle(.expanded)

    }
}
