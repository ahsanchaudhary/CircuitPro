//
//  CanvasTapManager.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/21/25.
//
import SwiftUI
import Observation

import AppKit
import SwiftUI

extension EventModifiers {
    init(from flags: NSEvent.ModifierFlags) {
        var result: EventModifiers = []

        if flags.contains(.shift)    { result.insert(.shift) }
        if flags.contains(.command)  { result.insert(.command) }
        if flags.contains(.option)   { result.insert(.option) }
        if flags.contains(.control)  { result.insert(.control) }

        self = result
    }
}

@Observable
class CanvasTapManager {
  private(set) var selectedIDs: Set<UUID> = []

  func handleTap(on optionalID: UUID?, modifiers: EventModifiers) {
    if let id = optionalID {
      if modifiers.contains(.shift) {
        toggleSelection(of: id)
      } else {
        selectOnly(id)
      }
    } else {
      if !modifiers.contains(.shift) {
        clearSelection()
      }
    }
  }
    func setSelected(_ ids: [UUID], modifiers: EventModifiers = []) {
       if modifiers.contains(.shift) {
         // Add to existing selection
         selectedIDs.formUnion(ids)
       } else {
         // Replace existing selection
         selectedIDs = Set(ids)
       }
     }

  private func toggleSelection(of id: UUID) {
    if selectedIDs.contains(id) {
      selectedIDs.remove(id)
    } else {
      selectedIDs.insert(id)
    }
  }

  private func selectOnly(_ id: UUID) {
    selectedIDs = [id]
  }

  func clearSelection() {
    selectedIDs.removeAll()
  }

  func isSelected(_ id: UUID) -> Bool {
    selectedIDs.contains(id)
  }
}
