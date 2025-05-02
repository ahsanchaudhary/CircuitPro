//
//  ComponentDesignManager.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/19/25.
//


import SwiftUI
import Observation

@Observable
final class ComponentDesignManager {
    
    var componentName: String = ""
    var componentAbbreviation: String = ""
    
    var selectedCategory: ComponentCategory?
    
    var componentProperties: [ComponentProperty] = [ComponentProperty(key: nil, value: .single(nil), unit: .init())]
    
    
    // MARK: - Symbol
    var symbolElements: [CanvasElement] = []
    var symbolInteraction =
    CanvasInteractionManager<CanvasElement, UUID>(idProvider: \.id)
    
    var selectedTool: AnyCanvasTool? = nil
    
    
    
    // MARK: - Footprint
    
}


// Extract all pin objects from symbolElements
extension ComponentDesignManager {
    var allPins: [Pin] {
        symbolElements.compactMap { elem in
            if case .pin(let pin) = elem { return pin }
            else { return nil }
        }
    }

    // Get the indices of all selected pins
    var selectedPinIndices: [Int] {
        symbolElements.enumerated().compactMap { (i, elem) in
            if let id = symbolInteraction.selectedIDs.first(where: { $0 == elem.id }),
               case .pin = elem {
                return i
            }
            return nil
        }
    }

    // Binding to array of selected pins, for use in PinEditorView
    func bindingForSelectedPins() -> Binding<[Pin]> {
        Binding<[Pin]>(
            get: {
                // Get current Pin values at those indices
                self.selectedPinIndices.compactMap {
                    if case .pin(let pin) = self.symbolElements[$0] { return pin }
                    else { return nil }
                }
            },
            set: { newValue in
                // Mutate pins at those indices
                for (offset, idx) in self.selectedPinIndices.enumerated() {
                    if case .pin = self.symbolElements[idx], offset < newValue.count {
                        self.symbolElements[idx] = .pin(newValue[offset])
                    }
                }
            }
        )
    }
}
