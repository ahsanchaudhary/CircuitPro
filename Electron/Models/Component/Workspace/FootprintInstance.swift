//
//  SymbolInstance 2.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/14/25.
//


import SwiftData
import SwiftUI

@Model
final class FootprintInstance  {
    
     var uuid: UUID
    
     var footprintId: UUID
    
    init(uuid: UUID, footprintId: UUID) {
        self.uuid = uuid
        self.footprintId = footprintId
    }

}
