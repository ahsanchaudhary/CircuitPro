//import SwiftData
//import Foundation
//
//struct ModelContainerManager {
//    /// Creates a unified ModelContainer composed of two configurations:
//    /// - "workspace": A writable container that holds project-level instance models.
//    /// - "appLibrary": A read-only container for default/preloaded components.
//    static func initializeContainer() throws -> ModelContainer {
//        // Writable configuration: your workspace models.
//        let workspaceConfig = ModelConfiguration(
//            "workspace",
//            schema: Schema([
//                Project.self,
//                Schematic.self,
//                Layout.self,
//                Layer.self,
//                Net.self,
//                Via.self,
//                ComponentInstance.self,
//                SymbolInstance.self,
//                FootprintInstance.self
//            ]),
//            allowsSave: true
//        )
//
//        // Read-only configuration: your preloaded app library.
//        let appLibraryConfig = ModelConfiguration(
//            "appLibrary",
//            schema: Schema([
//                Component.self,
//                Symbol.self,
//                Footprint.self,
//                Model.self
//            ]),
//            allowsSave: false
//        )
//
//        // Create one unified container that handles both configurations.
//        return try ModelContainer(
//            for: Project.self,
//            Schematic.self,
//            Layout.self,
//            Layer.self,
//            Net.self,
//            Via.self,
//            ComponentInstance.self,
//            SymbolInstance.self,
//            FootprintInstance.self,
//            Component.self,
//            Symbol.self,
//            Footprint.self,
//            Model.self,
//            configurations: [workspaceConfig, appLibraryConfig]  // Pass as an array literal.
//        )
//    }
//}
