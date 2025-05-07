import SwiftUI
import Observation

struct HandleDragEdit {
    let elementIndex: Int
    let newElement: CanvasElement
}

@Observable
class CanvasInteractionManager<Item> {
    // MARK: Public API
    private(set) var selectedIDs: Set<UUID> = []
    let dragManager: CanvasDragManager<Item, UUID>
    
    enum DragMode {
        case none
        case moveItem
        case handle(PrimitiveHandle, AnyPrimitive, CGPoint) // handle, originalPrimitive, dragStart
    }
    var dragMode: DragMode = .none

    init(idProvider: @escaping (Item) -> UUID) {
        self.dragManager = CanvasDragManager(idProvider: idProvider)
        self.idProvider  = idProvider
    }

    func tap(
        at location: CGPoint,
        items: [Item],
        hitTest: (Item, CGPoint) -> Bool,
        drawToolActive: Bool,
        modifiers: EventModifiers
    ) {
        if drawToolActive { return }
        
        if let hit = items.reversed().first(where: { hitTest($0, location) }) {
            let id = idProvider(hit)
            if modifiers.contains(.shift) {
                if selectedIDs.contains(id) { selectedIDs.remove(id) }
                else                        { selectedIDs.insert(id) }
            } else {
                selectedIDs = [id]
            }
        } else if !modifiers.contains(.shift) {
            selectedIDs.removeAll()
        }
    }

    /// Returns: (edit, didHandle)
    func drag(
        phase: ContinuousGesturePhase,
        location: CGPoint,
        translation: CGSize,
        proxy: AdvancedScrollViewProxy,
        items: [Item],
        hitTest: (Item, CGPoint) -> Bool,
        positionForItem: (Item) -> SDPoint,
        setPositionForItem: @escaping (Item, SDPoint) -> Void,
        snapping: @escaping (CGPoint) -> CGPoint
    ) -> (HandleDragEdit?, Bool) {

        switch phase {
        case .possible:
            let selectedPrimitives: [AnyPrimitive] = items.compactMap {
                if case .primitive(let p) = $0 as? CanvasElement { return p }
                else { return nil }
            }.filter { selectedIDs.contains($0.id) }

            let handles = allHandles(selected: selectedPrimitives)
            if let hit = handles.first(where: { $0.position.distance(to: location) < 12 }),
               let primitive = selectedPrimitives.first(where: { $0.id == hit.primitiveID }) {
                dragMode = .handle(hit, primitive, location)
                return (nil, true) // claim gesture!
            }

            if dragManager.handleDrag(
                phase: .possible, location: location, translation: translation,
                proxy: proxy, items: items, hitTest: hitTest, positionForItem: positionForItem,
                setPositionForItem: {_,_ in}, selectedIDs: selectedIDs, snapping: snapping
            ) {
                gestureMode = .drag
                return (nil, true)
            } else {
                gestureMode = .none
                return (nil, false)
            }

        case .began, .changed:
            if case .handle(let handle, let original, let dragStart) = dragMode {
                let edit = handlePrimitiveHandleDrag(
                    handle: handle,
                    original: original,
                    dragStart: dragStart,
                    currentLocation: location,
                    symbolElements: items as! [CanvasElement],
                    snapping: snapping
                )
                return (edit, true)
            } else if gestureMode == .drag {
                let handled = dragManager.handleDrag(
                    phase: phase, location: location, translation: translation,
                    proxy: proxy, items: items.filter { selectedIDs.contains(idProvider($0)) },
                    hitTest: hitTest, positionForItem: positionForItem,
                    setPositionForItem: setPositionForItem, selectedIDs: selectedIDs,
                    snapping: snapping
                )
                return (nil, handled)
            } else {
                return (nil, false)
            }

        case .ended, .cancelled:
            if case .handle = dragMode {
                dragMode = .none
                return (nil, true)
            } else if gestureMode == .drag {
                let handled = dragManager.handleDrag(
                    phase: phase, location: location, translation: translation,
                    proxy: proxy, items: items.filter { selectedIDs.contains(idProvider($0)) },
                    hitTest: hitTest, positionForItem: positionForItem,
                    setPositionForItem: setPositionForItem, selectedIDs: selectedIDs,
                    snapping: snapping
                )
                gestureMode = .none
                return (nil, handled)
            } else {
                return (nil, false)
            }
        @unknown default:
            return (nil, false)
        }
    }
    
    func handlePrimitiveHandleDrag(
        handle: PrimitiveHandle,
        original: AnyPrimitive,
        dragStart: CGPoint,
        currentLocation: CGPoint,
        symbolElements: [CanvasElement],
        snapping: (CGPoint) -> CGPoint
    ) -> HandleDragEdit? {
        guard let idx = symbolElements.firstIndex(where: { $0.id == handle.primitiveID }) else { return nil }
        let snappedLocation = snapping(currentLocation)

        switch (handle.kind, original) {
        case (.rectangleCorner(let dir), .rectangle(var r)):
            let halfW = r.size.width/2, halfH = r.size.height/2
            let fixedCorner = CGPoint(
                x: r.position.x - dir.dx * halfW,
                y: r.position.y - dir.dy * halfH
            )
            let movingStart = CGPoint(
                x: r.position.x + dir.dx * halfW,
                y: r.position.y + dir.dy * halfH
            )
            let delta = CGPoint(x: snappedLocation.x - dragStart.x, y: snappedLocation.y - dragStart.y)
            let pointer = CGPoint(
                x: movingStart.x + delta.x,
                y: movingStart.y + delta.y
            )
            let newWidth = max(1, abs(pointer.x - fixedCorner.x))
            let newHeight = max(1, abs(pointer.y - fixedCorner.y))
            let newCenter = CGPoint(
                x: (pointer.x + fixedCorner.x) / 2,
                y: (pointer.y + fixedCorner.y) / 2
            )
            r.position = newCenter
            r.size = CGSize(width: newWidth, height: newHeight)
            return HandleDragEdit(elementIndex: idx, newElement: .primitive(.rectangle(r)))
        case (.circleRadius, .circle(var c)):
            let newRadius = max(1, c.position.distance(to: snappedLocation))
            c.radius = newRadius
            return HandleDragEdit(elementIndex: idx, newElement: .primitive(.circle(c)))
        case (.lineStart, .line(var l)):
            l.start = snappedLocation
            return HandleDragEdit(elementIndex: idx, newElement: .primitive(.line(l)))
        case (.lineEnd, .line(var l)):
            l.end = snappedLocation
            return HandleDragEdit(elementIndex: idx, newElement: .primitive(.line(l)))
        default:
            return nil
        }
    }

    // MARK: Internals
    private let idProvider: (Item) -> UUID
    private var gestureMode: GestureMode = .none
    private enum GestureMode { case none, drag }
    private var currentModifiers: EventModifiers {
        EventModifiers(from: NSApp.currentEvent?.modifierFlags ?? [])
    }
}

extension CanvasInteractionManager {
    func selectID(_ id: UUID) {
        selectedIDs.insert(id)
    }
    func deselectID(_ id: UUID) {
        selectedIDs.remove(id)
    }
    func toggleID(_ id: UUID) {
        if selectedIDs.contains(id) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
    }
    func selectOnly(_ id: UUID) {
        selectedIDs = [id]
    }
    /// Returns the id of the only selected primitive, or nil if none/multiple primitives selected
    func soleSelectedPrimitiveID(from elements: [CanvasElement]) -> UUID? {
        let selectedPrimitives = elements.compactMap { element -> UUID? in
            if case .primitive(let p) = element, selectedIDs.contains(p.id) { return p.id } else { return nil }
        }
        return selectedPrimitives.count == 1 ? selectedPrimitives.first : nil
    }
}
