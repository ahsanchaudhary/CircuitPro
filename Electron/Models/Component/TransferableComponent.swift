//
//  TransferrableComponent.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/15/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct TransferableComponent: Transferable, Codable {
    let componentUuid: UUID
    let symbolUuid: UUID
    let properties: [ComponentProperty]
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .transferableComponent)
    }
}


extension UTType {
    static let transferableComponent = UTType(exportedAs: "com.electron.transferable-component-data")
}
