//  CanvasInteractionController.swift
//  Electron_Tests
//
//  Created by Giorgi Tchelidze on 5/16/25.
//
import AppKit

// MARK: - CanvasInteractionController.swift
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

    init(canvas: CoreGraphicsCanvasView) {
        self.canvas = canvas
    }

    func mouseDown(at loc: CGPoint, event: NSEvent) {
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
                }.map(\ .id)
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
            for element in canvas.elements where canvas.selectedIDs.contains(element.id) && element.isPrimitiveEditable {
                for h in element.handles() where hypot(loc.x - h.position.x, loc.y - h.position.y) < 8 {
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

        // ── 1. raw drag vector ────────────────────────────────────────────────
        let rawDX = loc.x - origin.x
        let rawDY = loc.y - origin.y

        // ── 2. snap the *delta* to grid multiples (helper lives in CanvasView) ─
        let snappedDX = canvas.snapDelta(rawDX)
        let snappedDY = canvas.snapDelta(rawDY)

        // ── 3. move every selected element by the snapped delta ───────────────
        var updated = canvas.elements
        for i in updated.indices {
            let id = updated[i].id
            guard let original = originalPositions[id] else { continue }

            let newPos = CGPoint(x: original.x + snappedDX,
                                 y: original.y + snappedDY)

            let current = updated[i].primitives.first?.position ?? original
            let delta   = CGPoint(x: newPos.x - current.x,
                                  y: newPos.y - current.y)

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
            let pinCount = canvas.elements.reduce(0) { count, el in
                if case .pin = el { return count + 1 } else { return count }
            }
            let context = CanvasToolContext(existingPinCount: pinCount)
            let snapped = canvas.snap(loc)
            if let newElement = tool.handleTap(at: snapped, context: context) {

                canvas.elements.append(newElement)
                canvas.onUpdate?(canvas.elements)
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


