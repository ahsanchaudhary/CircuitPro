//
//  Misc.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/9/25.
//

//  Misc.swift
import SwiftUI
import AppKit

@available(macOS 10.15, *)
extension EdgeInsets {
    init(_ nsEdgeInsets: NSEdgeInsets) {
        self.init(top: nsEdgeInsets.top,
                  leading: nsEdgeInsets.left,
                  bottom: nsEdgeInsets.bottom,
                  trailing: nsEdgeInsets.right)
    }
}

@available(macOS 10.15, *)
extension NSEdgeInsets {
    init(_ edgeInsets: EdgeInsets) {
        self.init(top: edgeInsets.top,
                  left: edgeInsets.leading,
                  bottom: edgeInsets.bottom,
                  right: edgeInsets.trailing)
    }
}

//EOF
