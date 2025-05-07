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
    var selectedPackageType: PackageType?
    var componentProperties: [ComponentProperty] = [ComponentProperty(key: nil, value: .single(nil), unit: .init())]
    
    
    // MARK: - Symbol
    var symbolElements: [CanvasElement] = []
    var symbolInteraction = CanvasInteractionManager<CanvasElement>(idProvider: { $0.id })
    
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
                self.selectedPinIndices.compactMap {
                    if case .pin(let pin) = self.symbolElements[$0] { return pin }
                    else { return nil }
                }
            },
            set: { newValue in
                let pinIndexMap = Dictionary(uniqueKeysWithValues:
                    self.symbolElements.enumerated().compactMap { idx, elem in
                        if case .pin(let pin) = elem { return (pin.id, idx) } else { return nil }
                    }
                )
                for pin in newValue {
                    if let idx = pinIndexMap[pin.id] {
                        self.symbolElements[idx] = .pin(pin)
                    }
                }
            }
        )
    }
    
    func bindingForPin(with id: UUID) -> Binding<Pin>? {
        guard let idx = symbolElements.firstIndex(where: {
            if case .pin(let pin) = $0 { return pin.id == id } else { return false }
        }) else { return nil }
        return Binding<Pin>(
            get: {
                if case .pin(let pin) = self.symbolElements[idx] { return pin }
                else { fatalError("Pin missing!") }
            },
            set: { newValue in
                self.symbolElements[idx] = .pin(newValue)
            }
        )
    }
}
