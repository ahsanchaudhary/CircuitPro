import SwiftUI
import Observation

@Observable
class CanvasDragManager<Item, ID: Hashable> {

    struct DragState {
        let draggedID: ID
        let startLocation: CGPoint
        var translation: CGSize = .zero
        let initialPositions: [ID: SDPoint]
    }

    var dragState: DragState?
    private let idProvider: (Item) -> ID

    init(idProvider: @escaping (Item) -> ID) {
        self.idProvider = idProvider
    }

    @discardableResult
    func handleDrag(
        phase: ContinuousGesturePhase,
        location: CGPoint,
        translation: CGSize,
        proxy: AdvancedScrollViewProxy,

        items: [Item],

        hitTest: (Item, CGPoint) -> Bool,
        positionForItem: (Item) -> SDPoint,
        setPositionForItem: @escaping (Item, SDPoint) -> Void,
        selectedIDs: Set<ID>,
        snapping: @escaping (CGPoint) -> CGPoint = { $0 }
    ) -> Bool {
        switch phase {
        case .possible:
            return items.reversed().contains { hitTest($0, location) }

        case .began:
            guard let dragged = items.reversed().first(where: { hitTest($0, location) }) else {
                return false
            }

            let draggedID = idProvider(dragged)
            let activeIDs: Set<ID> = selectedIDs.contains(draggedID)
                ? selectedIDs
                : [draggedID]

            let initialMap = items.reduce(into: [ID: SDPoint]()) { dict, item in
                let id = idProvider(item)
                if activeIDs.contains(id) {
                    dict[id] = positionForItem(item)
                }
            }

            dragState = DragState(
                draggedID: draggedID,
                startLocation: location,
                translation: .zero,
                initialPositions: initialMap
            )
            return true

        case .changed:
            guard var s = dragState else { return false }

            // Calculate movement delta
            if let initial = s.initialPositions[s.draggedID] {
                let start = CGPoint(x: initial.x, y: initial.y)
                let moved = CGPoint(x: start.x + translation.width,
                                    y: start.y + translation.height)
                let snap = snapping(moved)
                s.translation = CGSize(width: snap.x - start.x,
                                       height: snap.y - start.y)
                dragState = s
                return true
            }

            return false

        case .cancelled:
            dragState = nil
            return true

        case .ended:
            guard let s = dragState else { return false }
            defer { dragState = nil }

            for (id, start) in s.initialPositions {
                let moved = CGPoint(
                    x: start.x + s.translation.width,
                    y: start.y + s.translation.height
                )
                let final = snapping(moved)

                if let item = items.first(where: { idProvider($0) == id }) {
                    setPositionForItem(item, SDPoint(final))
                }
            }

            return true
        }
    }

    func dragOffset(for item: Item) -> CGSize {
        guard let s = dragState else { return .zero }
        return s.initialPositions.keys.contains(idProvider(item)) ? s.translation : .zero
    }

    func dragOpacity(for item: Item) -> Double {
        guard let s = dragState else { return 1.0 }
        return s.initialPositions.keys.contains(idProvider(item)) ? 0.75 : 1.0
    }
}


protocol CanvasGestureHandler {
  /// called in .possible; do I want to claim this gesture?
  func canBegin(at location: CGPoint) -> Bool

  /// called in .began; return true if I begin handling
  func began(phase: ContinuousGesturePhase, location: CGPoint) -> Bool

  /// called in .changed; return true if I’m still handling
  func changed(phase: ContinuousGesturePhase, location: CGPoint, translation: CGSize) -> Bool

  /// called in .ended/.cancelled; finish up and return true if I handled
  func ended(phase: ContinuousGesturePhase, location: CGPoint, translation: CGSize) -> Bool
}

@Observable
class MarqueeSelectionManager: CanvasGestureHandler {
  private(set) var start: CGPoint?
  private(set) var end: CGPoint?

  var marqueeRect: CGRect? {
    guard let s = start, let e = end else { return nil }
    return CGRect(
      x: min(s.x, e.x), y: min(s.y, e.y),
      width: abs(e.x - s.x), height: abs(e.y - s.y)
    )
  }

  func canBegin(at location: CGPoint) -> Bool {
    // claim it if the drag manager didn’t hit anything
    true
  }

  func began(phase: ContinuousGesturePhase, location: CGPoint) -> Bool {
    start = location
    end = location
    return true
  }

  func changed(phase: ContinuousGesturePhase, location: CGPoint, translation: CGSize) -> Bool {
    end = location
    return true
  }

  func ended(phase: ContinuousGesturePhase, location: CGPoint, translation: CGSize) -> Bool {
    defer { start = nil; end = nil }
    guard let rect = marqueeRect else { return false }
    // compute selection inside rect here...
    return true
  }
}
