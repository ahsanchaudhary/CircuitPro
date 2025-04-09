//
//  AdvancedScrollView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/9/25.
//

//  AdvancedScrollView.swift
import SwiftUI

@available(macOS 10.15, *)
public struct AdvancedScrollView<Content: View>: View {

    public let magnification: Magnification
    public let isScrollIndicatorVisible: Bool

    let content: (_ proxy: AdvancedScrollViewProxy) -> Content

    public init(magnification: Magnification = Magnification(range: 1.0...4.0, initialValue: 1.0, isRelative: true),
                isScrollIndicatorVisible: Bool = true,
                @ViewBuilder content: @escaping (_ proxy: AdvancedScrollViewProxy) -> Content) {
        self.init(magnification: magnification,
                  isScrollIndicatorVisible: isScrollIndicatorVisible,
                  tapContentGestureInfo: nil,
                  dragContentGestureInfo: nil,
                  content: content)
    }

    init(magnification: Magnification,
         isScrollIndicatorVisible: Bool,
         tapContentGestureInfo: TapContentGestureInfo?,
         dragContentGestureInfo: DragContentGestureInfo?,
         @ViewBuilder content: @escaping (_ proxy: AdvancedScrollViewProxy) -> Content) {
        self.magnification = magnification
        self.isScrollIndicatorVisible = isScrollIndicatorVisible
        self.tapContentGestureInfo = tapContentGestureInfo
        self.dragContentGestureInfo = dragContentGestureInfo
        self.content = content
    }

    public var body: some View {
        NSScrollViewRepresentable(magnification: magnification,
                                  hasScrollers: isScrollIndicatorVisible,
                                  tapContentGestureInfo: tapContentGestureInfo,
                                  dragContentGestureInfo: dragContentGestureInfo,
                                  content: content)
    }

    var tapContentGestureInfo: TapContentGestureInfo?
    var dragContentGestureInfo: DragContentGestureInfo?
}
//EOF
