//
//  NSScrollViewRepresentable.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/9/25.
//

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

    func makeNSView(context: Context) -> NSScrollViewSubclass {
        let scrollView = NSScrollViewSubclass()
        scrollView.minMagnification = magnification.range.lowerBound
        scrollView.maxMagnification = magnification.range.upperBound
        scrollView.magnification = magnification.initialValue
        scrollView.hasHorizontalScroller = hasScrollers
        scrollView.hasVerticalScroller = hasScrollers
        scrollView.allowsMagnification = true
        scrollView.contentView = NSClipViewSubclass()

        if let tap = tapContentGestureInfo {
            scrollView.onClickGesture(count: tap.count) { [unowned scrollView] location in
                let proxy = makeProxy(scrollView: scrollView)
                tap.action(location, proxy)
            }
        }

        if let drag = dragContentGestureInfo {
            scrollView.onPanGesture { [unowned scrollView] state, location, translation in
                let proxy = makeProxy(scrollView: scrollView)
                return drag.action(state, location, CGSize(width: translation.x, height: translation.y), proxy)
            }
        }

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollViewSubclass, context: Context) {
        let proxy = makeProxy(scrollView: nsView)
        let contentView = content(proxy)

        if let hostingView = nsView.documentView as? NSHostingViewSubclass<Content> {
            hostingView.rootView = contentView
        } else {
            nsView.documentView = NSHostingViewSubclass(rootView: contentView)
        }

        nsView.documentView?.frame = CGRect(origin: .zero, size: nsView.documentView?.fittingSize ?? .zero)
    }

    private func makeProxy(scrollView: NSScrollViewSubclass) -> AdvancedScrollViewProxy {
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
