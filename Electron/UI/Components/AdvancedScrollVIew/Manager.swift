
//  Managers.swift

import SwiftUI
import Observation

@Observable
class ScrollViewManager {
    var proxy: AdvancedScrollViewProxy?
    var currentMagnification: CGFloat = 1.0
}

//EOF
