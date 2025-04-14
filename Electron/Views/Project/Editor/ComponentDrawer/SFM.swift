//
//  SymbolItem.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/8/25.
//

import SwiftUI

struct SymbolItem: Identifiable {
    var id: UUID = UUID()
    var name: String
}

struct FootprintItem: Identifiable {
    var id: UUID = UUID()
    var name: String
}

struct ModelItem: Identifiable {
    var id: UUID = UUID()
    var name: String
    var thumbnail: String?
}
