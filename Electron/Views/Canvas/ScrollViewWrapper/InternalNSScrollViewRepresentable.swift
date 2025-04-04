////
////  InternalNSScrollViewRepresentable.swift
////  Electron
////
////  Created by Giorgi Tchelidze on 4/4/25.
////
//
//#if os(macOS)
//
//import AppKit
//import SwiftUI
//import Combine
//
//
//struct InternalNSScrollViewRepresentable<Content: View>: NSViewRepresentable {
//
//    @Binding var zoomScaleBinding: CGFloat
//
//    let magnificationRange: ClosedRange<CGFloat>
//    let canvasSize: CGSize
//    let hasScrollers: Bool
//    let tapContentGestureInfo: TapContentGestureInfo?
//    let dragContentGestureInfo: DragContentGestureInfo?
//    let content: (_ proxy: ScrollViewWrapperProxy) -> Content
//
//    func makeNSView(context: Context) -> NSScrollViewSubclass {
//        let scrollView = NSScrollViewSubclass()
//        scrollView.minMagnification = magnificationRange.lowerBound
//        scrollView.maxMagnification = magnificationRange.upperBound
//        scrollView.magnification = zoomScaleBinding
//
//        scrollView.hasHorizontalScroller = hasScrollers
//        scrollView.hasVerticalScroller = hasScrollers
//        scrollView.allowsMagnification = true
//
//        let clipView = NSClipViewSubclass()
//        scrollView.contentView = clipView
//        scrollView.documentView = NSHostingViewSubclass(rootView: EmptyView())
//
//        context.coordinator.scrollView = scrollView
//
//        if let tapInfo = tapContentGestureInfo {
//            scrollView.onClickGesture(count: tapInfo.count) { [unowned scrollView] location in
//                let proxy = makeProxy(scrollView: scrollView, coordinator: context.coordinator)
//                tapInfo.action(location, proxy)
//            }
//        }
//
//        if let dragInfo = dragContentGestureInfo {
//            scrollView.onPanGesture { [unowned scrollView] state, location, translation in
//                let proxy = makeProxy(scrollView: scrollView, coordinator: context.coordinator)
//                return dragInfo.action(state, location, CGSize(width: translation.x, height: translation.y), proxy)
//            }
//        }
//
//        context.coordinator.observeMagnificationChanges()
//        return scrollView
//    }
//
//    func updateNSView(_ nsView: NSScrollViewSubclass, context: Context) {
//        let proxy = makeProxy(scrollView: nsView, coordinator: context.coordinator)
//        let newContentView = content(proxy)
//
//        if let hostingView = nsView.documentView as? NSHostingViewSubclass<Content> {
//            if hostingView.rootViewUpdatingNeeded(newContentView: newContentView) {
//                hostingView.rootView = newContentView
//            }
//        } else {
//            let hostingView = NSHostingViewSubclass(rootView: newContentView)
//            nsView.documentView = hostingView
//        }
//
//        if let documentView = nsView.documentView, documentView.frame.size != canvasSize {
//            documentView.frame = CGRect(origin: .zero, size: canvasSize)
//        }
//
//        let desiredScale = zoomScaleBinding
//        let currentScale = nsView.magnification
//        let tolerance: CGFloat = 0.001
//        if abs(desiredScale - currentScale) > tolerance {
//            nsView.setMagnification(desiredScale, centeredAt: nsView.magnificationCenterPoint)
//        }
//
//        if nsView.minMagnification != magnificationRange.lowerBound {
//            nsView.minMagnification = magnificationRange.lowerBound
//        }
//        if nsView.maxMagnification != magnificationRange.upperBound {
//            nsView.maxMagnification = magnificationRange.upperBound
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(zoomScaleBinding: $zoomScaleBinding)
//    }
//
//    class Coordinator: NSObject {
//        @Binding var zoomScaleBinding: CGFloat
//        weak var scrollView: NSScrollViewSubclass?
//        private var notificationCancellable: AnyCancellable?
//
//        init(zoomScaleBinding: Binding<CGFloat>) {
//            self._zoomScaleBinding = zoomScaleBinding
//        }
//
//        func observeMagnificationChanges() {
//            guard let scrollView = scrollView else { return }
//
//            notificationCancellable = NotificationCenter.default
//                .publisher(for: NSScrollView.didEndLiveMagnifyNotification, object: scrollView)
//                .merge(with:
//                    NotificationCenter.default
//                        .publisher(for: NSView.boundsDidChangeNotification, object: scrollView.contentView)
//                        .debounce(for: .milliseconds(50), scheduler: RunLoop.main)
//                )
//                .compactMap { [weak self] _ in self?.scrollView?.magnification }
//                .removeDuplicates { abs($0 - $1) < 0.001 }
//                .sink { [weak self] newMagnification in
//                    guard let self = self else { return }
//                    if abs(self.zoomScaleBinding - newMagnification) > 0.001 {
//                        self.zoomScaleBinding = newMagnification
//                    }
//                }
//        }
//
//        deinit {
//            notificationCancellable?.cancel()
//        }
//    }
//
//    private func makeProxy(scrollView: NSScrollViewSubclass, coordinator: Coordinator) -> ScrollViewWrapperProxy {
//        var proxy = ScrollViewWrapperProxy()
//
//        proxy.performScrollTo = { [weak scrollView] rect, animated in
//            let center = CGPoint(x: rect.midX, y: rect.midY)
//            scrollView?.scroll(center)
//        }
//
//        proxy.getContentOffset = { [weak scrollView] in
//            scrollView?.contentView.bounds.origin ?? .zero
//        }
//
//        proxy.setContentOffset = { [weak scrollView] contentOffset in
//            scrollView?.contentView.scroll(to: contentOffset)
//            scrollView?.reflectScrolledClipView(scrollView!.contentView)
//        }
//
//        proxy.getContentSize = { [weak scrollView] in
//            scrollView?.documentView?.bounds.size ?? .zero
//        }
//
//        proxy.getContentInset = { [weak scrollView] in
//            EdgeInsets(scrollView?.contentInsets ?? NSEdgeInsets())
//        }
//
//        proxy.setContentInset = { [weak scrollView] in
//            scrollView?.contentInsets = NSEdgeInsets($0)
//        }
//
//        proxy.getVisibleRect = { [weak scrollView] in
//            scrollView?.documentVisibleRect ?? .zero
//        }
//
//        proxy.getScrollerInsets = { [weak scrollView] in
//            EdgeInsets(scrollView?.scrollerInsets ?? NSEdgeInsets())
//        }
//
//        proxy.getMagnification = { [weak scrollView] in
//            scrollView?.magnification ?? 1.0
//        }
//
//        proxy.getIsLiveMagnify = { [weak scrollView] in
//            scrollView?.isLiveMagnify ?? false
//        }
//
//        proxy.getIsAutoscrollEnabled = { [weak scrollView] in
//            scrollView?.isAutoscrollEnabled ?? true
//        }
//
//        proxy.setIsAutoscrollEnabled = { [weak scrollView] in
//            scrollView?.isAutoscrollEnabled = $0
//        }
//
//        proxy.performSetMagnification = { [weak scrollView, weak coordinator] scale, animated in
//            guard let scrollView = scrollView else { return }
//            let clampedScale = max(scrollView.minMagnification, min(scrollView.maxMagnification, scale))
//            let tolerance: CGFloat = 0.001
//            if abs(scrollView.magnification - clampedScale) > tolerance {
//                scrollView.setMagnification(clampedScale, centeredAt: scrollView.magnificationCenterPoint)
//                DispatchQueue.main.async {
//                    if let coord = coordinator, abs(coord.zoomScaleBinding - clampedScale) > tolerance {
//                        coord.zoomScaleBinding = clampedScale
//                    }
//                }
//            }
//        }
//
//        return proxy
//    }
//}
//
//
//final class NSScrollViewSubclass: NSScrollView {
//    private(set) var isLiveMagnify: Bool = false
//    var isAutoscrollEnabled: Bool = true
//    private var notificaitonsCancellables: Set<AnyCancellable> = []
//
//    var magnificationCenterPoint: NSPoint {
//        let visibleRect = documentVisibleRect
//        return NSPoint(x: visibleRect.midX, y: visibleRect.midY)
//    }
//
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        NotificationCenter.default.publisher(for: NSScrollView.willStartLiveMagnifyNotification, object: self)
//            .sink { [weak self] _ in self?.isLiveMagnify = true }
//            .store(in: &notificaitonsCancellables)
//        NotificationCenter.default.publisher(for: NSScrollView.didEndLiveMagnifyNotification, object: self)
//            .sink { [weak self] _ in self?.isLiveMagnify = false }
//            .store(in: &notificaitonsCancellables)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    typealias ClickGestureAction = (_ location: CGPoint) -> Void
//    private weak var clickGestureRecognizer: NSClickGestureRecognizer?
//    private var clickGestureAction: ClickGestureAction?
//
//    func onClickGesture(count: Int = 1, perform action: ClickGestureAction?) {
//        if let action = action {
//            resetClickGesture()
//            let selector = #selector(handleClick(gestureRecognizer:))
//            let gr = NSClickGestureRecognizer(target: self, action: selector)
//            gr.numberOfClicksRequired = count
//            gr.numberOfTouchesRequired = 1
//            contentView.addGestureRecognizer(gr)
//            clickGestureRecognizer = gr
//            clickGestureAction = action
//        } else {
//            resetClickGesture()
//        }
//    }
//
//    @objc func handleClick(gestureRecognizer: NSClickGestureRecognizer) {
//        guard let action = clickGestureAction else { return }
//        let location = gestureRecognizer.location(in: documentView)
//        action(location)
//    }
//
//    private func resetClickGesture() {
//        if let gr = clickGestureRecognizer {
//            contentView.removeGestureRecognizer(gr)
//        }
//        clickGestureRecognizer = nil
//        clickGestureAction = nil
//    }
//
//    typealias PanGestureAction = (_ phase: ContinuousGesturePhase, _ location: CGPoint, _ translation: CGPoint) -> Bool
//    private weak var panGestureRecognizer: NSAutoscrollPanGestureRecognizer?
//    private var panGestureAction: PanGestureAction?
//
//    func onPanGesture(perform action: PanGestureAction?) {
//        if let action = action {
//            resetPanGesture()
//            let selector = #selector(handlePan(gestureRecognizer:))
//            let gr = NSAutoscrollPanGestureRecognizer(target: self, action: selector)
//            gr.numberOfTouchesRequired = 1
//            contentView.addGestureRecognizer(gr)
//            panGestureRecognizer = gr
//            panGestureAction = action
//        } else {
//            resetPanGesture()
//        }
//    }
//
//    @objc func handlePan(gestureRecognizer: NSAutoscrollPanGestureRecognizer) {
//        guard let action = panGestureAction, let docView = documentView,
//              let phase = ContinuousGesturePhase(gestureRecognizer.state) else { return }
//
//        if isAutoscrollEnabled, gestureRecognizer.isContentSelected, phase == .changed,
//           let event = gestureRecognizer.mouseDraggedEvent {
//            let before = documentVisibleRect
//            docView.autoscroll(with: event)
//            gestureRecognizer.translationOffset += documentVisibleRect.origin - before.origin
//        }
//
//        let location = gestureRecognizer.location(in: docView)
//        let translation = gestureRecognizer.translation(in: docView)
//        gestureRecognizer.isContentSelected = action(phase, location, translation)
//    }
//
//    private func resetPanGesture() {
//        if let gr = panGestureRecognizer {
//            contentView.removeGestureRecognizer(gr)
//        }
//        panGestureRecognizer = nil
//        panGestureAction = nil
//    }
//}
//
//final class NSClipViewSubclass: NSClipView {}
//
//final class NSHostingViewSubclass<Content: View>: NSHostingView<Content> {
//    func rootViewUpdatingNeeded(newContentView: Content) -> Bool {
//        return true // Could be optimized with custom logic
//    }
//}
//
//class NSAutoscrollPanGestureRecognizer: NSPanGestureRecognizer {
//    private(set) var mouseDraggedEvent: NSEvent?
//    override func mouseDragged(with event: NSEvent) {
//        super.mouseDragged(with: event)
//        mouseDraggedEvent = event
//    }
//
//    var translationOffset: NSPoint = .zero
//    override func translation(in view: NSView?) -> NSPoint {
//        super.translation(in: view) + translationOffset
//    }
//
//    var isContentSelected: Bool = false
//    override func reset() {
//        super.reset()
//        mouseDraggedEvent = nil
//        translationOffset = .zero
//        isContentSelected = false
//    }
//}
//
//extension ContinuousGesturePhase {
//    init?(_ state: NSGestureRecognizer.State) {
//        switch state {
//        case .possible: self = .possible
//        case .began: self = .began
//        case .changed: self = .changed
//        case .cancelled, .failed: self = .cancelled
//        case .ended: self = .ended
//        default: return nil
//        }
//    }
//}
//
//extension EdgeInsets {
//    init(_ nsEdgeInsets: NSEdgeInsets) {
//        self.init(top: nsEdgeInsets.top, leading: nsEdgeInsets.left, bottom: nsEdgeInsets.bottom, trailing: nsEdgeInsets.right)
//    }
//}
//
//extension NSEdgeInsets {
//    init(_ edgeInsets: EdgeInsets) {
//        self.init(top: edgeInsets.top, left: edgeInsets.leading, bottom: edgeInsets.bottom, right: edgeInsets.trailing)
//    }
//}
//
//#endif
