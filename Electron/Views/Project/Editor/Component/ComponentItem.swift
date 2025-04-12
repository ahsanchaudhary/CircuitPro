//
//  ComponentItem.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/8/25.
//
import SwiftUI


struct ComponentItem: Identifiable {
    var id: UUID = UUID()
    var name: String
    
    
    var properties: [ComponentProperty] = []
    var symbol: SymbolItem
    var footprint: FootprintItem?
    var model: ModelItem?
}


