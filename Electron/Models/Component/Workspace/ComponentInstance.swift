//
//  ComponentInstance.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/14/25.
//

import SwiftData
import SwiftUI

@Model
final class ComponentInstance  {
    
     var uuid: UUID
    
     var componentId: UUID
    
    init(uuid: UUID, componentId: UUID) {
        self.uuid = uuid
        self.componentId = componentId
    }

}
