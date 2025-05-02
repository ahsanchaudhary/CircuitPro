
//  AdvancedScrollView.swift
import SwiftUI


public struct AdvancedScrollView<Content: View>: View {
    // Access the shared model via EnvironmentObject
    @Environment(\.scrollViewManager) var manager
    
    public let magnificationRange: ClosedRange<CGFloat>
    
    let content: () -> Content // Content closure no longer takes proxy directly
    
    // Public initializer with default values
    public init(magnificationRange: ClosedRange<CGFloat> = (0.5...50.0),
                isScrollIndicatorVisible: Bool = true,
                @ViewBuilder content: @escaping () -> Content) {
        self.init(magnificationRange: magnificationRange,
                  tapContentGestureInfo: nil,
                  dragContentGestureInfo: nil,
                  content: content)
    }
    
    // Internal initializer with gesture info
    init(magnificationRange: ClosedRange<CGFloat>,
         tapContentGestureInfo: TapContentGestureInfo?,
         dragContentGestureInfo: DragContentGestureInfo?,
         @ViewBuilder content: @escaping () -> Content) {
        self.magnificationRange = magnificationRange
        self.tapContentGestureInfo = tapContentGestureInfo
        self.dragContentGestureInfo = dragContentGestureInfo
        self.content = content
    }
    
    public var body: some View {
        NSScrollViewRepresentable(manager: manager,
                                  magnificationRange: magnificationRange,
                                  tapContentGestureInfo: tapContentGestureInfo,
                                  dragContentGestureInfo: dragContentGestureInfo,
                                  content: content)
    }
    
    // Private properties for gesture info
    var tapContentGestureInfo: TapContentGestureInfo?
    var dragContentGestureInfo: DragContentGestureInfo?
}
//EOF
