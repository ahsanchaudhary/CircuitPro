//
//  ComponentInstance 2.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/14/25.
//


import SwiftData
import SwiftUI

@Model
final class SymbolInstance  {
    
     var uuid: UUID
    
     var symbolId: UUID
    
    init(uuid: UUID, symbolId: UUID) {
        self.uuid = uuid
        self.symbolId = symbolId
    }

}
