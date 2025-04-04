//
//  SchematicView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/2/25.
//

import SwiftUI
import SwiftUI
import AdvancedScrollView // Ensure this is imported where DragContentAction etc. are used

struct Symbol: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var initialPosition: CGPoint? // To store position at drag start
}

// Structure to hold drag state information
struct DragState {
    var symbolId: UUID
    var startLocation: CGPoint // Drag start location in content coordinates
    var translation: CGSize = .zero // Current translation from startLocation
}

struct SchematicView: View {
    @State private var symbols: [Symbol] = [
        Symbol(x: 100, y: 100),
        Symbol(x: 300, y: 200),
        Symbol(x: 150, y: 350)
    ]


    // State to manage the drag operation
    @State private var dragState: DragState? = nil

    var body: some View {
        
        CanvasView { // Use your custom CanvasView
            ForEach(symbols.indices, id: \.self) { index in
                // Pass immutable Symbol, DraggableSymbol doesn't need binding anymore
                // for its own position if parent handles drag
                 DraggableSymbol(symbol: symbols[index])
                    // Apply visual feedback if this symbol is being dragged
                    .opacity(dragState?.symbolId == symbols[index].id ? 0.5 : 1.0)
                    .offset(dragState?.symbolId == symbols[index].id ? dragState!.translation : .zero) // Show live dragging preview
            }
        }
        // *** Attach the drag gesture handler to CanvasView ***
        .onDragContentGesture { phase, location, translation, proxy in
            handleDrag(phase: phase, location: location, translation: translation, proxy: proxy)
        }
        .onTapContentGesture { location, proxy in
            print("Canvas tapped at \(location)")
            // Deselect or select symbols based on tap location if needed
        }
  
       
    }

    // Drag handling logic extracted for clarity
    private func handleDrag(phase: ContinuousGesturePhase, location: CGPoint, translation: CGSize, proxy: AdvancedScrollViewProxy) -> Bool {

        switch phase {
        case .possible:
            // Check if the drag starts on any symbol. If yes, allow the drag.
            return hitTestSymbol(at: location) != nil

        case .began:
            // Find which symbol was hit (if any)
            if let hitIndex = hitTestSymbol(at: location) {
                let symbolId = symbols[hitIndex].id
                // Store initial state for the drag
                symbols[hitIndex].initialPosition = CGPoint(x: symbols[hitIndex].x, y: symbols[hitIndex].y)
                dragState = DragState(symbolId: symbolId, startLocation: location)
                print("Began dragging symbol: \(symbolId)")
                return true // We are handling this drag
            }
            return false // Didn't start on a symbol, don't handle it (allow default pan)

        case .changed:
            guard dragState != nil else { return false } // Should have state if drag began
            // Update the translation in the drag state
            dragState?.translation = translation
            // Live update happens via the .offset modifier in the ForEach loop
            return true // Continue handling

        case .cancelled:
            print("Drag cancelled")
            // Reset the position to initial state if cancelled
            if let draggedId = dragState?.symbolId, let index = symbols.firstIndex(where: { $0.id == draggedId }) {
                 if let initialPos = symbols[index].initialPosition {
                    symbols[index].x = initialPos.x
                    symbols[index].y = initialPos.y
                 }
                 symbols[index].initialPosition = nil // Clear temp state
            }
            dragState = nil // Clear drag state
            return true

        case .ended:
            print("Drag ended")
            // Finalize the position change in the data model
            if let draggedId = dragState?.symbolId, let index = symbols.firstIndex(where: { $0.id == draggedId }) {
                if let initialPos = symbols[index].initialPosition {
                    symbols[index].x = initialPos.x + translation.width
                    symbols[index].y = initialPos.y + translation.height
                }
                symbols[index].initialPosition = nil // Clear temp state
            }
            dragState = nil // Clear drag state
            return true
        }
    }

    // Helper function to find which symbol (if any) is at a given location
    private func hitTestSymbol(at location: CGPoint) -> Int? {
        // Iterate backwards to hit top-most symbol first
        for index in symbols.indices.reversed() {
            let symbol = symbols[index]
            let symbolRect = CGRect(x: symbol.x - 15, y: symbol.y - 15, width: 30, height: 30) // Symbol's frame (center based)
            if symbolRect.contains(location) {
                return index
            }
        }
        return nil
    }
}


struct DraggableSymbol: View {
    // Now just takes the data, doesn't manage drag state itself
    let symbol: Symbol

    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 30, height: 30)
            // Position is now directly from the Symbol data
            // The parent view handles updating this data during drag
            .position(x: symbol.x, y: symbol.y)
    }
}

#Preview {
    SchematicView()
}
