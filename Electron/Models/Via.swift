//
//  Via.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/6/25.
//

import SwiftUI
import SwiftData


@Model
final class Via {

    var position: Position
    var net: Net?
    var layout: Layout?
    var startLayer: Layer?
    var endLayer: Layer?
    

    
    init(position: Position, net: Net? = nil, layout: Layout? = nil, startLayer: Layer? = nil, endLayer: Layer? = nil) {
        self.position = position
        self.net = net
        self.layout = layout
        self.startLayer = startLayer
        self.endLayer = endLayer
   
    }
}

struct Position: Codable {
    var x: CGFloat
    var y: CGFloat

}


