
//  AdvancedScrollView+Gestures.swift
import SwiftUI

struct TapContentGestureInfo {
    var count: Int
    var action: TapContentAction
}

struct DragContentGestureInfo {
    var action: DragContentAction
}

public typealias TapContentAction = (_ location: CGPoint, _ proxy: AdvancedScrollViewProxy) -> Void

public typealias DragContentAction = (_ phase: ContinuousGesturePhase, _ location: CGPoint, _ translation: CGSize, _ proxy: AdvancedScrollViewProxy) -> Bool

public extension AdvancedScrollView {
    func onTapContentGesture(count: Int = 1, perform action: @escaping TapContentAction) -> AdvancedScrollView {
        let tapContentGestureInfo = TapContentGestureInfo(count: count, action: action)
        return AdvancedScrollView(magnificationRange: magnificationRange,
                                 
                                  tapContentGestureInfo: tapContentGestureInfo,
                                  dragContentGestureInfo: dragContentGestureInfo,
                                  content: content)
    }

    func onDragContentGesture(perform action: @escaping DragContentAction) -> AdvancedScrollView {
        let dragContentGestureInfo = DragContentGestureInfo(action: action)
        return AdvancedScrollView(magnificationRange: magnificationRange,
                                 
                                  tapContentGestureInfo: tapContentGestureInfo,
                                  dragContentGestureInfo: dragContentGestureInfo,
                                  content: content)
    }
}

extension NSScrollViewRepresentable {
     func setupTapGesture(for scrollView: NSScrollViewSubclass, coordinator: Coordinator) {
        guard tapContentGestureInfo != nil else { return }
        let tap = NSClickGestureRecognizer(
            target: coordinator,
            action: #selector(Coordinator.handleTapGesture(_:))
        )
        tap.numberOfClicksRequired = tapContentGestureInfo?.count ?? 1
        tap.delegate = coordinator
        scrollView.contentView.addGestureRecognizer(tap)
    }

     func setupPanGesture(for scrollView: NSScrollViewSubclass, coordinator: Coordinator) {
        guard dragContentGestureInfo != nil else { return }
        let pan = NSAutoscrollPanGestureRecognizer(
            target: coordinator,
            action: #selector(Coordinator.handlePanGesture(_:))
        )
        pan.delegate = coordinator
        scrollView.contentView.addGestureRecognizer(pan)
    }
}
//EOF
