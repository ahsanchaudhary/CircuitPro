// MARK: - CanvasView.swift
import AppKit

final class CanvasView: NSView {

    // MARK: Public API
    var elements: [CanvasElement] = [] {
        didSet { needsDisplay = true }
    }

    var selectedIDs: Set<UUID> = [] {
        didSet {
            needsDisplay = true
            if selectedIDs != oldValue { onSelectionChange?(selectedIDs) }
        }
    }

    var magnification: CGFloat = 1.0
    var isSnappingEnabled: Bool = true
    var snapGridSize: CGFloat = 10.0

    var onUpdate: (([CanvasElement]) -> Void)?
    var onSelectionChange: ((Set<UUID>) -> Void)?

    // MARK: Private Controllers
    private lazy var interaction = CanvasInteractionController(canvas: self)
    private lazy var drawing = CanvasDrawingController(canvas: self)
    private lazy var hitTesting = CanvasHitTestController(canvas: self)
    
    var selectedTool: AnyCanvasTool?

    override var isFlipped: Bool { true }

    override init(frame: NSRect) {
        super.init(frame: .init(origin: .zero, size: .init(width: 5000, height: 5000)))
        wantsLayer = true
    }

    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ dirtyRect: NSRect) {
        guard let ctx = NSGraphicsContext.current?.cgContext else { return }
        hitTesting.updateRects()
        drawing.draw(in: ctx, dirtyRect: dirtyRect)
    }
    
    override func mouseMoved(with event: NSEvent) {
        needsDisplay = true
    }


    override func mouseDown(with event: NSEvent) {
        
        interaction.mouseDown(at: convert(event.locationInWindow, from: nil), event: event)
    }

    override func mouseDragged(with event: NSEvent) {
        interaction.mouseDragged(to: convert(event.locationInWindow, from: nil), event: event)
    }

    override func mouseUp(with event: NSEvent) {
        interaction.mouseUp(at: convert(event.locationInWindow, from: nil), event: event)
    }

    func snap(_ point: CGPoint) -> CGPoint {
        guard isSnappingEnabled else { return point }
        func snapValue(_ v: CGFloat) -> CGFloat {
            round(v / snapGridSize) * snapGridSize
        }
        return CGPoint(x: snapValue(point.x), y: snapValue(point.y))
    }
    
    func snapDelta(_ value: CGFloat) -> CGFloat {
        let g = snapGridSize
        return round(value / g) * g
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach(removeTrackingArea)

        let area = NSTrackingArea(
            rect: bounds,
            options: [.mouseMoved, .activeInKeyWindow, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(area)
    }


    // MARK: Internal Accessors for Controllers
    var hitRects: CanvasHitTestController { hitTesting }
    var marqueeRect: CGRect? { interaction.marqueeRect } // ✅ Expose safely
}



