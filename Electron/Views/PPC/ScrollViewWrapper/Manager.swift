
//  Managers.swift

import SwiftUI
import Observation

@Observable
class ScrollViewManager {
    var proxy: AdvancedScrollViewProxy?
    var currentMagnification: CGFloat = 1.0
}


private struct ScrollViewManagerKey: EnvironmentKey {
    static let defaultValue: ScrollViewManager = ScrollViewManager()
}

extension EnvironmentValues {
    var scrollViewManager: ScrollViewManager {
        get { self[ScrollViewManagerKey.self] }
        set { self[ScrollViewManagerKey.self] = newValue }
    }
}


//EOF
