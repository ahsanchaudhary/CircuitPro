
//  NSScrollViewRepresentable.swift

import AppKit
import SwiftUI

struct NSScrollViewRepresentable<Content: View>: NSViewRepresentable {
    let manager: ScrollViewManager
    let magnificationRange: ClosedRange<CGFloat>
    let tapContentGestureInfo: TapContentGestureInfo?
    let dragContentGestureInfo: DragContentGestureInfo?
    let content: () -> Content // Content closure no longer takes proxy
    
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
                  let documentView = scrollView.documentView,
                  let proxy = parent.manager.proxy else { return }
            let location = gesture.location(in: documentView)
            action(location, proxy)
        }
        
        // MARK: - Pan Gesture Handler
        @objc func handlePanGesture(_ gesture: NSAutoscrollPanGestureRecognizer) {
            guard let action = parent.dragContentGestureInfo?.action,
                  let scrollView = gesture.view?.superview as? NSScrollViewSubclass,
                  let documentView = scrollView.documentView,
                  let phase = ContinuousGesturePhase(gesture.state),
                  let proxy = parent.manager.proxy else { return }
            let location = gesture.location(in: documentView)
            let translation = gesture.translation(in: documentView)
            _ = action(phase, location, CGSize(width: translation.x, height: translation.y), proxy)
        }
        
        // MARK: - Gesture Recognizer Delegate
        func gestureRecognizerShouldBegin(_ gestureRecognizer: NSGestureRecognizer) -> Bool {
            if let panGesture = gestureRecognizer as? NSPanGestureRecognizer,
               let scrollView = panGesture.view?.superview as? NSScrollViewSubclass,
               let documentView = scrollView.documentView,
               let action = parent.dragContentGestureInfo?.action,
               let proxy = parent.manager.proxy {
                let location = gestureRecognizer.location(in: documentView)
                let translationPoint = panGesture.translation(in: documentView)
                let translationSize = CGSize(width: translationPoint.x, height: translationPoint.y)
                return action(.possible, location, translationSize, proxy)
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
        scrollView.minMagnification = magnificationRange.lowerBound
        scrollView.maxMagnification = magnificationRange.upperBound
        scrollView.hasHorizontalScroller = true
        scrollView.hasVerticalScroller = true
        scrollView.allowsMagnification = true
        scrollView.contentView = NSClipView()
        
        scrollView.onMagnificationChange = { newMagnification in
                   DispatchQueue.main.async {
                       self.manager.currentMagnification = newMagnification
                   }
               }
        
        setupTapGesture(for: scrollView, coordinator: context.coordinator)
        setupPanGesture(for: scrollView, coordinator: context.coordinator)
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollViewSubclass, context: Context) {
        let proxy = makeProxy(for: nsView)
        manager.proxy = proxy // Set the proxy in the model
        let contentView = content()
        
        if let hostingView = nsView.documentView as? NSHostingView<AnyView> {
            hostingView.rootView = AnyView(contentView)
        } else {
            nsView.documentView = NSHostingView(rootView: AnyView(contentView))
        }
        nsView.documentView?.frame = CGRect(
            origin: .zero,
            size: nsView.documentView?.fittingSize ?? .zero
        )
    }
    
    // MARK: - Helper to Create Proxy
    fileprivate func makeProxy(for scrollView: NSScrollViewSubclass) -> AdvancedScrollViewProxy {
        var proxy = AdvancedScrollViewProxy()
        
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
        
        proxy.setMagnification = { newMagnification in
            let minMag = scrollView.minMagnification
            let maxMag = scrollView.maxMagnification
            let boundedValue = min(max(newMagnification, minMag), maxMag)
            scrollView.magnification = boundedValue
            DispatchQueue.main.async {
                self.manager.currentMagnification = boundedValue
            }
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
