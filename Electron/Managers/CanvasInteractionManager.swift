//
//  CanvasInteractionManager.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/27/25.
//


import SwiftUI
import Observation

/// Encapsulates tap-selection, drag, marquee, snapping, multi-select, live‐offsets, opacity, etc.
@Observable
class CanvasInteractionManager<Item, ID: Hashable> {
  // MARK: Public API
  /// What your view binds to for whether an item is selected
  private(set) var selectedIDs: Set<ID> = []
  
  /// Where to read live drag-offset & opacity in your view
  let dragManager: CanvasDragManager<Item, ID>
  
  /// What to draw as the marquee rectangle overlay
  private let marqueeManager = MarqueeSelectionManager()
  var marqueeRect: CGRect? { marqueeManager.marqueeRect }
  
  /// Construct with the same idProvider you’d have given your dragManager
  init(idProvider: @escaping (Item) -> ID) {
    self.dragManager = CanvasDragManager(idProvider: idProvider)
    self.idProvider  = idProvider
  }
  
  // MARK: Tap selection
  /// Call this from your .onTapContentGesture
  func tap(
    at location: CGPoint,
    items: [Item],
    hitTest: (Item, CGPoint) -> Bool,
    drawToolActive: Bool,              // true = cursor tool, false = drawing tool
    modifiers: EventModifiers
  ) {
    if drawToolActive {
      // you’re in “draw a new primitive” mode—don’t change selection
      return
    }
    
    // cursor mode → select
    if let hit = items.reversed().first(where: { hitTest($0, location) }) {
      let id = idProvider(hit)
      if modifiers.contains(.shift) {
        // add/remove
        if selectedIDs.contains(id) { selectedIDs.remove(id) }
        else                        { selectedIDs.insert(id) }
      } else {
        // replace
        selectedIDs = [id]
      }
    } else if !modifiers.contains(.shift) {
      // tapped empty space → clear
      selectedIDs.removeAll()
    }
  }
  
  // MARK: Drag & marquee
  /// Call this from your .onDragContentGesture; returns the Bool for SwiftUI
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
  ) -> Bool {
    // 1) capture marquee before it gets cleared
    let beforeMarquee = marqueeManager.marqueeRect
    
    // 2) dispatch to dragManager or marqueeManager
    let handled: Bool
    switch phase {
      
    case .possible:
      // if you hit an item, enter drag; otherwise marquee
      if dragManager.handleDrag(
        phase:       .possible,
        location:    location,
        translation: translation,
        proxy:       proxy,
        items:       items,
        hitTest:     hitTest,
        positionForItem: positionForItem,
        setPositionForItem: {_,_ in},
        selectedIDs: selectedIDs,
        snapping:    snapping
      ) {
        gestureMode = .drag
        handled = true
      } else {
        gestureMode = .marquee
        handled = marqueeManager.canBegin(at: location)
      }
      
    case .began:
      if gestureMode == .drag {
        // forward to drag
        handled = dragManager.handleDrag(
          phase: .began,
          location: location,
          translation: translation,
          proxy: proxy,
          items: items.filter { selectedIDs.contains(idProvider($0)) },
          hitTest: hitTest,
          positionForItem: positionForItem,
          setPositionForItem: setPositionForItem,
          selectedIDs: selectedIDs,
          snapping: snapping
        )
      } else {
        handled = marqueeManager.began(phase: .began, location: location)
      }
      
    case .changed:
      if gestureMode == .drag {
        handled = dragManager.handleDrag(
          phase: .changed,
          location: location,
          translation: translation,
          proxy: proxy,
          items: items.filter { selectedIDs.contains(idProvider($0)) },
          hitTest: hitTest,
          positionForItem: positionForItem,
          setPositionForItem: setPositionForItem,
          selectedIDs: selectedIDs,
          snapping: snapping
        )
      } else {
        handled = marqueeManager.changed(phase: .changed, location: location, translation: translation)
      }
      
    case .ended, .cancelled:
      if gestureMode == .drag {
        handled = dragManager.handleDrag(
          phase: phase,
          location: location,
          translation: translation,
          proxy: proxy,
          items: items.filter { selectedIDs.contains(idProvider($0)) },
          hitTest: hitTest,
          positionForItem: positionForItem,
          setPositionForItem: setPositionForItem,
          selectedIDs: selectedIDs,
          snapping: snapping
        )
      } else {
        handled = marqueeManager.ended(phase: phase, location: location, translation: translation)
      }
      gestureMode = .none
      
    @unknown default:
      handled = false
    }
    
    // 3) if the gesture *ended* in marquee mode, select everything inside that box
    if phase == .ended, let rect = beforeMarquee {
      let hits = items
        .filter { rect.contains(CGPoint(x: positionForItem($0).x,
                                        y: positionForItem($0).y)) }
        .map(idProvider)
      if currentModifiers.contains(.shift) {
        selectedIDs.formUnion(hits)
      } else {
        selectedIDs = Set(hits)
      }
    }
    
    return handled
  }
  
  // MARK: Internals
  private let idProvider: (Item) -> ID
  private var gestureMode: GestureMode = .none
  private enum GestureMode { case none, drag, marquee }
  private var currentModifiers: EventModifiers {
    EventModifiers(from: NSApp.currentEvent?.modifierFlags ?? [])
  }
}


extension CanvasInteractionManager {
    func selectID(_ id: ID) {
        selectedIDs.insert(id)
    }
    func deselectID(_ id: ID) {
        selectedIDs.remove(id)
    }
    func toggleID(_ id: ID) {
        if selectedIDs.contains(id) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
    }
    func selectOnly(_ id: ID) {
        selectedIDs = [id]
    }
}
