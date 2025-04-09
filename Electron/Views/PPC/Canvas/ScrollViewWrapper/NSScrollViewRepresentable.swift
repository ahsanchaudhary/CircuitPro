
//  NSScrollViewRepresentable.swift

import AppKit
import SwiftUI
import Combine

@available(macOS 10.15, *)
struct NSScrollViewRepresentable<Content: View>: NSViewRepresentable {

    let magnification: Magnification
    let hasScrollers: Bool
    let tapContentGestureInfo: TapContentGestureInfo?
    let dragContentGestureInfo: DragContentGestureInfo?
    let content: (_ proxy: AdvancedScrollViewProxy) -> Content

    // MARK: - Coordinator
    class Coordinator: NSObject, NSGestureRecognizerDelegate {
        var parent: NSScrollViewRepresentable

        init(parent: NSScrollViewRepresentable) {
            self.parent = parent
        }
        
        // MARK: - Tap Gesture Handler
        @objc func handleTapGesture(_ gesture: NSClickGestureRecognizer) {
            guard let action = parent.tapContentGestureInfo?.action,
                  let scrollView = gesture.view?.superview as? NSScrollViewSubclass,
                  let documentView = scrollView.documentView else { return }
            let location = gesture.location(in: documentView)
            let proxy = parent.makeProxy(for: scrollView)
            action(location, proxy)
        }
        
        // MARK: - Pan Gesture Handler
        @objc func handlePanGesture(_ gesture: NSAutoscrollPanGestureRecognizer) {
            guard let action = parent.dragContentGestureInfo?.action,
                  let scrollView = gesture.view?.superview as? NSScrollViewSubclass,
                  let documentView = scrollView.documentView,
                  let phase = ContinuousGesturePhase(gesture.state) else { return }
            let location = gesture.location(in: documentView)
            let translation = gesture.translation(in: documentView)
            let proxy = parent.makeProxy(for: scrollView)
            _ = action(phase, location, CGSize(width: translation.x, height: translation.y), proxy)
        }
        
        // Optional: Delegate method if you want to control gesture recognizer behavior further.
        func gestureRecognizerShouldBegin(_ gestureRecognizer: NSGestureRecognizer) -> Bool {
            if let panGesture = gestureRecognizer as? NSPanGestureRecognizer,
               let scrollView = panGesture.view?.superview as? NSScrollViewSubclass,
               let documentView = scrollView.documentView,
               let action = parent.dragContentGestureInfo?.action {
                let location = gestureRecognizer.location(in: documentView)
                let translationPoint = panGesture.translation(in: documentView)
                // Convert the NSPoint (CGPoint) to a CGSize
                let translationSize = CGSize(width: translationPoint.x, height: translationPoint.y)
                return action(.possible, location, translationSize, parent.makeProxy(for: scrollView))
            }
            return true
        }

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // MARK: - NSViewRepresentable Methods
    func makeNSView(context: Context) -> NSScrollViewSubclass {
        let scrollView = NSScrollViewSubclass()
        scrollView.minMagnification = magnification.range.lowerBound
        scrollView.maxMagnification = magnification.range.upperBound
        scrollView.magnification = magnification.initialValue
        scrollView.hasHorizontalScroller = hasScrollers
        scrollView.hasVerticalScroller = hasScrollers
        scrollView.allowsMagnification = true
        scrollView.contentView = NSClipViewSubclass()
        
        // Set up tap gesture if provided
        if tapContentGestureInfo != nil {
            let tapRecognizer = NSClickGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handleTapGesture(_:))
            )
            tapRecognizer.numberOfClicksRequired = tapContentGestureInfo?.count ?? 1
            tapRecognizer.numberOfTouchesRequired = 1
            tapRecognizer.delegate = context.coordinator
            // Add the recognizer to the contentView so that it intercepts content taps.
            scrollView.contentView.addGestureRecognizer(tapRecognizer)
        }
        
        // Set up pan gesture if provided
        if dragContentGestureInfo != nil {
            let panRecognizer = NSAutoscrollPanGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handlePanGesture(_:))
            )
            panRecognizer.numberOfTouchesRequired = 1
            panRecognizer.delegate = context.coordinator
            scrollView.contentView.addGestureRecognizer(panRecognizer)
        }
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollViewSubclass, context: Context) {
        let proxy = makeProxy(for: nsView)
        let contentView = content(proxy)
        
        if let hostingView = nsView.documentView as? NSHostingViewSubclass<Content> {
            hostingView.rootView = contentView
        } else {
            nsView.documentView = NSHostingViewSubclass(rootView: contentView)
        }
        // Optionally update the documentView’s frame to fit the content.
        nsView.documentView?.frame = CGRect(
            origin: .zero,
            size: nsView.documentView?.fittingSize ?? .zero
        )
    }
    
    // MARK: - Helper to create a proxy
    fileprivate func makeProxy(for scrollView: NSScrollViewSubclass) -> AdvancedScrollViewProxy {
        var proxy = AdvancedScrollViewProxy()

        proxy.performScrollTo = { rect, animated in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            scrollView.scroll(center)
        }

        proxy.getContentOffset = {
            scrollView.contentView.bounds.origin
        }

        proxy.setContentOffset = { offset in
            let point = scrollView.contentView.convert(offset, to: scrollView.documentView)
            scrollView.documentView?.scroll(point)
        }

        proxy.getContentSize = {
            scrollView.documentView?.bounds.size ?? .zero
        }

        proxy.getContentInset = {
            EdgeInsets(scrollView.contentInsets)
        }

        proxy.setContentInset = {
            scrollView.contentInsets = NSEdgeInsets($0)
        }

        proxy.getVisibleRect = {
            scrollView.documentVisibleRect
        }

        proxy.getScrollerInsets = {
            EdgeInsets(scrollView.scrollerInsets)
        }

        proxy.getMagnification = {
            scrollView.magnification
        }

        proxy.getIsLiveMagnify = {
            scrollView.isLiveMagnify
        }

        proxy.getIsAutoscrollEnabled = {
            scrollView.isAutoscrollEnabled
        }

        proxy.setIsAutoscrollEnabled = {
            scrollView.isAutoscrollEnabled = $0
        }

        return proxy
    }
}

//EOF
