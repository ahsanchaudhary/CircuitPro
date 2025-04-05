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
    @State var manager = CanvasManager()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Project.self,
            Schematic.self,
            Layout.self,
            PCBLayer.self,
            Net.self
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
        .environment(\.canvasManager, manager)
    }
}
