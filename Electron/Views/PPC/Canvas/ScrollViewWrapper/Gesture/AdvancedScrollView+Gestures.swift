
//  AdvancedScrollView+Gestures.swift
import SwiftUI

@available(macOS 10.15, *)
struct TapContentGestureInfo {
    var count: Int
    var action: TapContentAction
}

@available(macOS 10.15, *)
struct DragContentGestureInfo {
    var action: DragContentAction
}

@available(macOS 10.15, *)
public typealias TapContentAction = (_ location: CGPoint, _ proxy: AdvancedScrollViewProxy) -> Void

@available(macOS 10.15, *)
public typealias DragContentAction = (_ phase: ContinuousGesturePhase, _ location: CGPoint, _ translation: CGSize, _ proxy: AdvancedScrollViewProxy) -> Bool

@available(macOS 10.15, *)
public extension AdvancedScrollView {
    func onTapContentGesture(count: Int = 1, perform action: @escaping TapContentAction) -> AdvancedScrollView {
        let tapContentGestureInfo = TapContentGestureInfo(count: count, action: action)
        return AdvancedScrollView(magnification: magnification,
                                  isScrollIndicatorVisible: isScrollIndicatorVisible,
                                  tapContentGestureInfo: tapContentGestureInfo,
                                  dragContentGestureInfo: dragContentGestureInfo,
                                  content: content)
    }

    func onDragContentGesture(perform action: @escaping DragContentAction) -> AdvancedScrollView {
        let dragContentGestureInfo = DragContentGestureInfo(action: action)
        return AdvancedScrollView(magnification: magnification,
                                  isScrollIndicatorVisible: isScrollIndicatorVisible,
                                  tapContentGestureInfo: tapContentGestureInfo,
                                  dragContentGestureInfo: dragContentGestureInfo,
                                  content: content)
    }
}
//EOF
