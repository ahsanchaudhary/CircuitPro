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
    var selectedSymbolElementIDs: Set<UUID> = []
    var selectedSymbolTool: AnyCanvasTool = AnyCanvasTool(CursorTool())
    
    
    
    // MARK: - Footprint
    var footprintElements: [CanvasElement] = []
    var selectedFootprintElementIDs: Set<UUID> = []
    var selectedFootprintTool: AnyCanvasTool = AnyCanvasTool(CursorTool())
    
}

extension ComponentDesignManager {
    var pins: [Pin] {
        symbolElements.compactMap {
            if case .pin(let pin) = $0 {
                return pin
            }
            return nil
        }
    }
    
    var selectedPins: [Pin] {
        symbolElements.compactMap {
            if case .pin(let pin) = $0, selectedSymbolElementIDs.contains(pin.id) {
                return pin
            }
            return nil
        }
    }
    
    func bindingForPin(with id: UUID) -> Binding<Pin>? {
        guard let index = symbolElements.firstIndex(where: {
            if case .pin(let pin) = $0 { return pin.id == id }
            return false
        }) else {
            return nil
        }
        
        return Binding<Pin>(
            get: {
                if case .pin(let pin) = self.symbolElements[index] {
                    return pin
                } else {
                    fatalError("Unexpected non-pin element at index")
                }
            },
            set: { newValue in
                self.symbolElements[index] = .pin(newValue)
            }
        )
    }
    
}


extension ComponentDesignManager {
    var pads: [Pad] {
        footprintElements.compactMap {
            if case .pad(let pad) = $0 {
                return pad
            }
            return nil
        }
    }

    var selectedPads: [Pad] {
        footprintElements.compactMap {
            if case .pad(let pad) = $0, selectedFootprintElementIDs.contains(pad.id) {
                return pad
            }
            return nil
        }
    }

    func bindingForPad(with id: UUID) -> Binding<Pad>? {
        guard let index = footprintElements.firstIndex(where: {
            if case .pad(let pad) = $0 { return pad.id == id }
            return false
        }) else {
            return nil
        }

        return Binding<Pad>(
            get: {
                if case .pad(let pad) = self.footprintElements[index] {
                    return pad
                } else {
                    fatalError("Unexpected non-pad element at index")
                }
            },
            set: { newValue in
                self.footprintElements[index] = .pad(newValue)
            }
        )
    }
}
