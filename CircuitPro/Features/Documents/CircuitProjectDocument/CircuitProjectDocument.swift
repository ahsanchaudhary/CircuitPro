//
//  CircuitProjectDocument.swift
//  CircuitPro
//
//  Created by Giorgi Tchelidze on 21.05.25.
//


import SwiftUI
import UniformTypeIdentifiers

class CircuitProjectDocument: NSDocument {

    // MARK: model in memory
    var model = CircuitProjectModel()

    // MARK: SwiftUI window
    override func makeWindowControllers() {
        let hosting = NSHostingController(rootView: ContentView(project: model))
        addWindowController(NSWindowController(window: NSWindow(contentViewController: hosting)))
    }

    // ────────────────────────────────────────────────
    // 1️⃣  READ an existing .circuitproj  (URL-based)
    // ────────────────────────────────────────────────
    override func read(from url: URL, ofType typeName: String) throws {
        let data = try Data(contentsOf: url)
        model    = try JSONDecoder().decode(CircuitProjectModel.self, from: data)
    }

    // ────────────────────────────────────────────────
    // 2️⃣  WRITE / autosave  → raw bytes only
    // ────────────────────────────────────────────────
    override func data(ofType typeName: String) throws -> Data {
        try JSONEncoder().encode(model)
    }

    // (optional) tell AppKit which UTI we support
    override func writableTypes(for _: NSDocument.SaveOperationType) -> [String] {
        [UTType.circuitProject.identifier]  // ✅ Must match Info.plist
    }
    
    

}
