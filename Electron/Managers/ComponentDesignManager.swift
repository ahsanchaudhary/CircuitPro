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
    
    var selectedSymbolTool: AnyCanvasTool? = nil
    
    
    
    // MARK: - Footprint
    var footprintElements: [CanvasElement] = []
    var footprintInteraction = CanvasInteractionManager<CanvasElement>(idProvider: { $0.id })
    
    var selectedFootprintTool: AnyCanvasTool? = nil
    
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

extension ComponentDesignManager {
    // Extract all pad objects from symbolElements
    var allPads: [Pad] {
        footprintElements.compactMap { elem in
            if case .pad(let pad) = elem { return pad }
            else { return nil }
        }
    }

    // Get the indices of all selected pads
    var selectedPadIndices: [Int] {
        footprintElements.enumerated().compactMap { (i, elem) in
            if let id = footprintInteraction.selectedIDs.first(where: { $0 == elem.id }),
               case .pad = elem {
                return i
            }
            return nil
        }
    }

    // Binding to array of selected pads, for use in a PadEditorView
    func bindingForSelectedPads() -> Binding<[Pad]> {
        Binding<[Pad]>(
            get: {
                self.selectedPadIndices.compactMap {
                    if case .pad(let pad) = self.footprintElements[$0] { return pad }
                    else { return nil }
                }
            },
            set: { newValue in
                let padIndexMap = Dictionary(uniqueKeysWithValues:
                    self.footprintElements.enumerated().compactMap { idx, elem in
                        if case .pad(let pad) = elem { return (pad.id, idx) } else { return nil }
                    }
                )
                for pad in newValue {
                    if let idx = padIndexMap[pad.id] {
                        self.footprintElements[idx] = .pad(pad)
                    }
                }
            }
        )
    }

    // Binding for a single pad by ID
    func bindingForPad(with id: UUID) -> Binding<Pad>? {
        guard let idx = footprintElements.firstIndex(where: {
            if case .pad(let pad) = $0 { return pad.id == id } else { return false }
        }) else { return nil }
        return Binding<Pad>(
            get: {
                if case .pad(let pad) = self.footprintElements[idx] { return pad }
                else { fatalError("Pad missing!") }
            },
            set: { newValue in
                self.footprintElements[idx] = .pad(newValue)
            }
        )
    }
}
