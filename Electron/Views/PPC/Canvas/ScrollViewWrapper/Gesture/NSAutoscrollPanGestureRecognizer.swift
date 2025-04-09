
//  NSAutoscrollPanGestureRecognizer.swift

import AppKit

/// NSPanGestureRecognizer subclass that keeps track of last mouse dragged event to use in autoscroll(with:) method.
final class NSAutoscrollPanGestureRecognizer: NSPanGestureRecognizer {

    private(set) var mouseDraggedEvent: NSEvent?

    override func mouseDragged(with event: NSEvent) {
        super.mouseDragged(with: event)
        mouseDraggedEvent = event
    }

    /// Offset to add to translation. Reset to `.zero` when gesture resets.
    var translationOffset: NSPoint = .zero

    override func translation(in view: NSView?) -> NSPoint {
        super.translation(in: view) + translationOffset
    }

    /// Indicates whether the user is selecting content, to enable autoscroll.
    var isContentSelected: Bool = false

    override func reset() {
        super.reset()
        mouseDraggedEvent = nil
        translationOffset = .zero
        isContentSelected = false
    }
}
//EOF

