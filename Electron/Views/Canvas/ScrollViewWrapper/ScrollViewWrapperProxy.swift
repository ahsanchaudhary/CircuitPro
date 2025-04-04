////
////  ScrollViewWrapperProxy.swift
////  Electron
////
////  Created by Giorgi Tchelidze on 4/4/25.
////
//
//
//import SwiftUI
//
//// Renamed Proxy
//struct ScrollViewWrapperProxy {
//
//    init() {} // Keep internal init accessible
//
//    // --- Existing Methods ---
//    public func scrollTo(_ rect: CGRect, animated: Bool) { /* ... same ... */
//        performScrollTo(rect, animated)
//    }
//    public var contentOffset: CGPoint { get { getContentOffset() } set { setContentOffset(newValue) } }
//    public var contentSize: CGSize { getContentSize() }
//    public var contentInset: EdgeInsets { get { getContentInset() } set { setContentInset(newValue) } }
//    public var visibleRect: CGRect { getVisibleRect() }
//    public var scrollerInsets: EdgeInsets { getScrollerInsets() }
//    public var magnification: CGFloat { getMagnification() } // Read current magnification
//    public var isLiveMagnify: Bool { getIsLiveMagnify() }
//    public var isAutoscrollEnabled: Bool { get { getIsAutoscrollEnabled() } set { setIsAutoscrollEnabled(newValue) } }
//
//    // --- NEW Method ---
//    public func setMagnification(_ scale: CGFloat, animated: Bool = false) {
//        performSetMagnification(scale, animated)
//    }
//
//
//    // --- Internal Closures ---
//    var performScrollTo: ((_ rect: CGRect, _ animated: Bool) -> Void)!
//    var getContentOffset: (() -> CGPoint)!
//    var setContentOffset: ((_ contentOffset: CGPoint) -> Void)!
//    var getContentSize: (() -> CGSize)!
//    var getContentInset: (() -> EdgeInsets)!
//    var setContentInset: ((_ contentInset: EdgeInsets) -> Void)!
//    var getVisibleRect: (() -> CGRect)!
//    var getScrollerInsets: (() -> EdgeInsets)!
//    var getMagnification: (() -> CGFloat)!
//    var getIsLiveMagnify: (() -> Bool)!
//    var getIsAutoscrollEnabled: (() -> Bool)!
//    var setIsAutoscrollEnabled: ((_ isAutoscrollEnabled: Bool) -> Void)!
//    // NEW
//    var performSetMagnification: ((_ scale: CGFloat, _ animated: Bool) -> Void)!
//}
