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

  func handleSelection(of id: UUID, with modifiers: EventModifiers) {
      if modifiers.contains(.command) {
      // Shift: toggle selection state
      toggleSelection(of: id)
    } else {
      // No modifier: select only this item
      selectOnly(id)
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


