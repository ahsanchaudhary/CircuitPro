//
//  CanvasTapManager.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/21/25.
//
import SwiftUI
import Observation

@Observable
class CanvasTapManager {
  private(set) var selectedIDs: Set<UUID> = []

  func toggleSelection(of id: UUID) {
    if selectedIDs.contains(id) {
      selectedIDs.remove(id)
    } else {
      selectedIDs.insert(id)
    }
  }

  func selectOnly(_ id: UUID) {
    selectedIDs = [id]
  }

  func clearSelection() {
    selectedIDs.removeAll()
  }

  func isSelected(_ id: UUID) -> Bool {
    selectedIDs.contains(id)
  }
}

