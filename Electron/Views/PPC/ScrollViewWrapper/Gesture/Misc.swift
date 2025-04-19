
//  Misc.swift
import SwiftUI
import AppKit

extension EdgeInsets {
    init(_ nsEdgeInsets: NSEdgeInsets) {
        self.init(top: nsEdgeInsets.top,
                  leading: nsEdgeInsets.left,
                  bottom: nsEdgeInsets.bottom,
                  trailing: nsEdgeInsets.right)
    }
}

extension NSEdgeInsets {
    init(_ edgeInsets: EdgeInsets) {
        self.init(top: edgeInsets.top,
                  left: edgeInsets.leading,
                  bottom: edgeInsets.bottom,
                  right: edgeInsets.trailing)
    }
}

//EOF
