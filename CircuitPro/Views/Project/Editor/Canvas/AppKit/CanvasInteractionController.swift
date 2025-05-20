import AppKit

final class CanvasInteractionController {
    unowned let canvas: CoreGraphicsCanvasView

    private var dragOrigin: CGPoint?
    private var tentativeSelection: Set<UUID>?
    private var originalPositions: [UUID: CGPoint] = [:]
    private var activeHandle: (UUID, Handle.Kind)?
    private var frozenOppositeWorld: CGPoint?
    private var didMoveSignificantly = false
    private let dragThreshold: CGFloat = 4.0

    private(set) var marqueeOrigin: CGPoint?
    private(set) var marqueeRect: CGRect?

    private var isRotatingViaMouse = false
    private var rotationOrigin: CGPoint?

    var isRotating: Bool { isRotatingViaMouse }

    init(canvas: CoreGraphicsCanvasView) {
        self.canvas = canvas
    }

    func enterRotationMode(around point: CGPoint) {
        isRotatingViaMouse = true
        rotationOrigin = point
    }

    func updateRotation(to cursor: CGPoint) {
        guard isRotatingViaMouse, let origin = rotationOrigin else { return }

        let dx = cursor.x - origin.x
        let dy = cursor.y - origin.y
        let rawAngle = atan2(dy, dx)

        var updated = canvas.elements
        for i in updated.indices where canvas.selectedIDs.contains(updated[i].id) {
            switch updated[i] {

            case .primitive(var prim):
                var angle = rawAngle
                if !NSEvent.modifierFlags.contains(.shift) {
                    // Snap to 15° increments
                    let snapIncrement: CGFloat = .pi / 12
                    angle = round(angle / snapIncrement) * snapIncrement
                }
                prim.rotation = angle
                updated[i] = .primitive(prim)

            case .pin(var pin):
                let snapped = CardinalRotation.closest(to: rawAngle)
                pin.rotation = snapped
                updated[i] = .pin(pin)

            case .pad(var pad):
                let snapped = CardinalRotation.closest(to: rawAngle)
                pad.rotation = snapped
                updated[i] = .pad(pad)
            }
        }

        canvas.elements = updated
        canvas.onUpdate?(updated)
        canvas.needsDisplay = true
    }






    func mouseDown(at loc: CGPoint, event: NSEvent) {
        if isRotatingViaMouse {
            isRotatingViaMouse = false
            rotationOrigin = nil
            return
        }

        if handleToolTap(at: loc) { return }

        beginInteraction(at: loc, event: event)

        if canvas.selectedTool?.id == "cursor",
           activeHandle == nil,
           canvas.hitRects.hitTest(at: loc) == nil {
            marqueeOrigin = loc
            marqueeRect = nil
        }
    }

    func mouseDragged(to loc: CGPoint, event: NSEvent) {
        guard let origin = dragOrigin else { return }
        updateMovementState(from: origin, to: loc)

        if let origin = marqueeOrigin, canvas.selectedTool?.id == "cursor" {
            marqueeRect = CGRect(origin: origin, size: .zero).union(CGRect(origin: loc, size: .zero))
            if let rect = marqueeRect {
                let ids = canvas.elements.filter {
                    $0.boundingBox.intersects(rect)
                }.map(\.id)
                canvas.selectedIDs = Set(ids)
            }
            return
        }

        if handleDraggingHandle(to: loc) { return }
        handleDraggingSelection(to: loc, from: origin)
    }

    func mouseUp(at loc: CGPoint, event: NSEvent) {
        defer {
            resetInteractionState()
            marqueeOrigin = nil
            marqueeRect = nil
            canvas.needsDisplay = true
        }

        if !didMoveSignificantly, let newSel = tentativeSelection {
            canvas.selectedIDs = newSel
        }
    }

    // MARK: - Internal helpers
    private func beginInteraction(at loc: CGPoint, event: NSEvent) {
        dragOrigin = loc
        didMoveSignificantly = false
        tentativeSelection = nil
        originalPositions.removeAll()
        frozenOppositeWorld = nil
        activeHandle = nil

        if canvas.selectedIDs.count == 1 {
            let tolerance = 8.0 / canvas.magnification
            for element in canvas.elements where canvas.selectedIDs.contains(element.id) && element.isPrimitiveEditable {
                for h in element.handles() where hypot(loc.x - h.position.x, loc.y - h.position.y) < tolerance {
                    activeHandle = (element.id, h.kind)
                    if let oppKind = oppositeKind(of: h.kind),
                       let opp = element.handles().first(where: { $0.kind == oppKind }) {
                        frozenOppositeWorld = opp.position
                    }
                    return
                }
            }
        }

        let shift = event.modifierFlags.contains(.shift)
        let hitID = canvas.hitRects.hitTest(at: loc)

        if let id = hitID {
            let wasSelected = canvas.selectedIDs.contains(id)
            if wasSelected {
                tentativeSelection = canvas.selectedIDs.subtracting([id])
                if !shift {
                    for element in canvas.elements where canvas.selectedIDs.contains(element.id) {
                        if let primitive = element.primitives.first {
                            originalPositions[element.id] = primitive.position
                        }
                    }
                }
            } else {
                tentativeSelection = shift ? canvas.selectedIDs.union([id]) : [id]
            }

            if let element = canvas.elements.first(where: { $0.id == id }),
               let primitive = element.primitives.first {
                originalPositions[id] = primitive.position
            }
        } else if !shift {
            tentativeSelection = []
        }
    }

    private func updateMovementState(from origin: CGPoint, to loc: CGPoint) {
        if !didMoveSignificantly && hypot(loc.x - origin.x, loc.y - origin.y) >= dragThreshold {
            didMoveSignificantly = true
        }
    }

    private func handleDraggingHandle(to loc: CGPoint) -> Bool {
        guard let (id, kind) = activeHandle else { return false }
        var updated = canvas.elements
        let snapped = canvas.snap(loc)
        for i in updated.indices where updated[i].id == id {
            updated[i].updateHandle(kind, to: snapped, opposite: frozenOppositeWorld)
            canvas.elements = updated
            canvas.onUpdate?(updated)
            return true
        }
        return false
    }

    private func handleDraggingSelection(to loc: CGPoint, from origin: CGPoint) {
        guard !originalPositions.isEmpty else { return }

        let rawDX = loc.x - origin.x
        let rawDY = loc.y - origin.y

        let snappedDX = canvas.snapDelta(rawDX)
        let snappedDY = canvas.snapDelta(rawDY)

        var updated = canvas.elements
        for i in updated.indices {
            let id = updated[i].id
            guard let original = originalPositions[id] else { continue }

            let newPos = CGPoint(x: original.x + snappedDX,
                                 y: original.y + snappedDY)

            let current = updated[i].primitives.first?.position ?? original
            let delta = CGPoint(x: newPos.x - current.x, y: newPos.y - current.y)

            updated[i].translate(by: delta)
        }

        canvas.elements = updated
        canvas.onUpdate?(updated)
    }

    private func resetInteractionState() {
        dragOrigin = nil
        originalPositions.removeAll()
        didMoveSignificantly = false
        activeHandle = nil
        frozenOppositeWorld = nil
    }

    private func handleToolTap(at loc: CGPoint) -> Bool {
        if var tool = canvas.selectedTool, tool.id != "cursor" {
            let pinCount = canvas.elements.reduce(0) { $1.isPin ? $0 + 1 : $0 }
            let padCount = canvas.elements.reduce(0) { $1.isPad ? $0 + 1 : $0 }
            let context = CanvasToolContext(
                existingPinCount: pinCount,
                existingPadCount: padCount,
                selectedLayer: canvas.selectedLayer
            )

            let snapped = canvas.snap(loc)
            if let newElement = tool.handleTap(at: snapped, context: context) {
                canvas.elements.append(newElement)
                canvas.onUpdate?(canvas.elements)

                if case .primitive(let prim) = newElement {
                    canvas.onPrimitiveAdded?(prim.id, context.selectedLayer)
                }
            }

            canvas.selectedTool = tool
            return true
        }
        return false
    }

    private func oppositeKind(of kind: Handle.Kind) -> Handle.Kind? {
        switch kind {
        case .rectTopLeft: return .rectBottomRight
        case .rectTopRight: return .rectBottomLeft
        case .rectBottomRight: return .rectTopLeft
        case .rectBottomLeft: return .rectTopRight
        case .lineStart: return .lineEnd
        case .lineEnd: return .lineStart
        default: return nil
        }
    }
}
