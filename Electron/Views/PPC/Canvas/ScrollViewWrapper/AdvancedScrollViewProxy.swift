
//  AdvancedScrollViewProxy.swift
import SwiftUI

public struct AdvancedScrollViewProxy {

    init() {}

    public var contentOffset: CGPoint {
        get { getContentOffset() }
        set { setContentOffset(newValue) }
    }

    public var contentSize: CGSize {
        getContentSize()
    }

    public var contentInset: EdgeInsets {
        get { getContentInset() }
        set { setContentInset(newValue) }
    }

    public var visibleRect: CGRect {
        getVisibleRect()
    }

    // Updated property: Now has both getter and setter.
    public var magnification: CGFloat {
        get { getMagnification() }
        set { setMagnification(newValue) }
    }

    public var isLiveMagnify: Bool {
        getIsLiveMagnify()
    }

    public var isAutoscrollEnabled: Bool {
        get { getIsAutoscrollEnabled() }
        set { setIsAutoscrollEnabled(newValue) }
    }

    // MARK: - Internal Implementation Hooks

    var getContentOffset: (() -> CGPoint)!
    var setContentOffset: ((_ contentOffset: CGPoint) -> Void)!
    var getContentSize: (() -> CGSize)!
    var getContentInset: (() -> EdgeInsets)!
    var setContentInset: ((_ contentInset: EdgeInsets) -> Void)!
    var getVisibleRect: (() -> CGRect)!
    var getScrollerInsets: (() -> EdgeInsets)!
    var getMagnification: (() -> CGFloat)!
    // New setter closure for programmatically setting the magnification.
    var setMagnification: ((_ newMagnification: CGFloat) -> Void)!
    var getIsLiveMagnify: (() -> Bool)!
    var getIsAutoscrollEnabled: (() -> Bool)!
    var setIsAutoscrollEnabled: ((_ isAutoscrollEnabled: Bool) -> Void)!
}

//EOF
