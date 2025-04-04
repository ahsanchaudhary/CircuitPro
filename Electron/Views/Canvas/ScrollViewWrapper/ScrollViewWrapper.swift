////
////  ScrollViewWrapper.swift
////  Electron
////
////  Created by Giorgi Tchelidze on 4/4/25.
////
//
//import SwiftUI
//import Combine // Needed for Coordinator
//
//// Define type aliases within this file or a shared location
//typealias TapContentAction = (_ location: CGPoint, _ proxy: ScrollViewWrapperProxy) -> Void
//typealias DragContentAction = (_ phase: ContinuousGesturePhase, _ location: CGPoint, _ translation: CGSize, _ proxy: ScrollViewWrapperProxy) -> Bool
//
//// Re-use ContinuousGesturePhase enum
//enum ContinuousGesturePhase { /* ... same as before ... */
//    case possible, began, changed, cancelled, ended
//}
//
//// Re-use Magnification struct
//struct Magnification { /* ... same as before ... */
//    let range: ClosedRange<CGFloat>
//    let initialValue: CGFloat // Keep for initial setup
//    let isRelative: Bool = false // Assuming absolute for canvas
//    init(range: ClosedRange<CGFloat>, initialValue: CGFloat) {
//        self.range = range
//        self.initialValue = initialValue
//    }
//}
//
//// Main Wrapper View
//struct ScrollViewWrapper<Content: View>: View {
//    let content: (_ proxy: ScrollViewWrapperProxy) -> Content
//
//    // --- Internal State ---
//    @State private var internalZoomScale: CGFloat
//    @State private var canvasSize: CGSize // Added - allow configuration
//
//    // --- Configuration ---
//    private var magnificationRange: ClosedRange<CGFloat>
//    private var scrollIndicatorVisible: Bool = true
//    private var onTapAction: TapContentAction?
//    private var onDragAction: DragContentAction?
//
//
//    // Private initializer used by config methods
//    private init(
//        initialZoom: CGFloat,
//        zoomRange: ClosedRange<CGFloat>,
//        canvasSize: CGSize, // Added
//        scrollIndicatorVisible: Bool,
//        content: @escaping (_ proxy: ScrollViewWrapperProxy) -> Content,
//        onTap: TapContentAction? = nil,
//        onDrag: DragContentAction? = nil
//    ) {
//        self._internalZoomScale = State(initialValue: initialZoom) // Initialize State
//        self.magnificationRange = zoomRange
//        self._canvasSize = State(initialValue: canvasSize) // Initialize State
//        self.scrollIndicatorVisible = scrollIndicatorVisible
//        self.content = content
//        self.onTapAction = onTap
//        self.onDragAction = onDrag
//    }
//
//    // Public Initializer
//    init(
//        initialZoom: CGFloat = 0.5,
//        zoomRange: ClosedRange<CGFloat> = 0.1...5.0,
//        canvasSize: CGSize = CGSize(width: 3000, height: 3000), // Provide default
//        scrollIndicatorVisible: Bool = true,
//        @ViewBuilder content: @escaping (_ proxy: ScrollViewWrapperProxy) -> Content
//    ) {
//       self.init(initialZoom: initialZoom,
//                 zoomRange: zoomRange,
//                 canvasSize: canvasSize,
//                 scrollIndicatorVisible: scrollIndicatorVisible,
//                 content: content,
//                 onTap: nil,
//                 onDrag: nil)
//    }
//
//    // --- Configuration Methods ---
//    func onTapContentGesture(perform action: @escaping TapContentAction) -> Self {
//        var newView = self
//        newView.onTapAction = action
//        return newView
//    }
//
//    func onDragContentGesture(perform action: @escaping DragContentAction) -> Self {
//        var newView = self
//        newView.onDragAction = action
//        return newView
//    }
//
//    // --- Body ---
//    var body: some View {
//        #if os(macOS)
//        // Pass the binding $internalZoomScale down
//        InternalNSScrollViewRepresentable(
//            zoomScaleBinding: $internalZoomScale, // Pass binding
//            magnificationRange: magnificationRange,
//            canvasSize: canvasSize, // Pass canvas size
//            hasScrollers: scrollIndicatorVisible,
//            tapContentGestureInfo: onTapAction.map { TapContentGestureInfo(count: 1, action: $0) },
//            dragContentGestureInfo: onDragAction.map { DragContentGestureInfo(action: $0) },
//            content: content
//        )
//        #else
//        // Fallback for other platforms if needed (using original representable for now)
//        Text("ScrollViewWrapper macOS Only")
//        // Or implement the UIKit version similarly if required
//        #endif
//    }
//
//    // --- Internal Programmatic Control ---
//    func setZoomProgrammatically(to newZoom: CGFloat, animated: Bool = false) {
//        let clampedZoom = max(magnificationRange.lowerBound, min(magnificationRange.upperBound, newZoom))
//        // Directly setting the state will trigger updateNSView in the representable
//        internalZoomScale = clampedZoom
//        // Note: Animation support would need to be added to the proxy/representable logic
//    }
//
//    func getCurrentZoom() -> CGFloat {
//        return internalZoomScale
//    }
//}
//
//// --- Gesture Info Structs (Internal Detail) ---
//struct TapContentGestureInfo {
//    var count: Int
//    var action: TapContentAction
//}
//
//struct DragContentGestureInfo {
//    var action: DragContentAction
//}
