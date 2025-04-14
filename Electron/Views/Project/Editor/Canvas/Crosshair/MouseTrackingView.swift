import SwiftUI
#if os(macOS)
import AppKit

/// NSView that tracks mouse movements
class TrackingNSView: NSView {
    var onMouseMoved: ((CGPoint) -> Void)?
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        // Only update if the current tracking area doesn't match the bounds
        if trackingAreas.first?.rect != bounds {
            for trackingArea in trackingAreas {
                removeTrackingArea(trackingArea)
            }
            let options: NSTrackingArea.Options = [
                .activeAlways,
                .mouseMoved,
                .inVisibleRect
            ]
            let trackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
            addTrackingArea(trackingArea)
        }
    }

    
    override func mouseMoved(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        
        // Flip the Y coordinate to match SwiftUI’s coordinate system
        let flippedPoint = CGPoint(
            x: point.x,
            y: bounds.height - point.y
        )
        
        onMouseMoved?(flippedPoint)
    }
}

/// SwiftUI wrapper for the NSView mouse tracker
struct MouseTrackingView: NSViewRepresentable {
    var onMouseMoved: (CGPoint) -> Void
    
    func makeNSView(context: Context) -> TrackingNSView {
        let view = TrackingNSView()
        view.onMouseMoved = onMouseMoved
        return view
    }
    
    func updateNSView(_ nsView: TrackingNSView, context: Context) {
        nsView.onMouseMoved = onMouseMoved
    }
}
#endif
