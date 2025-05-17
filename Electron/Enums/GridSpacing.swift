//
//  GridSpacing.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/11/25.
//
import SwiftUI

enum GridSpacing: CGFloat, Displayable {
  case mm5    = 5.0
  case mm2_5  = 2.5
  case mm1    = 1.0
  case mm0_5  = 0.5
  case mm0_25 = 0.25
  case mm0_1  = 0.1


  /// For showing in a Picker or menu
  var label: String {
    switch self {
    case .mm5:    return "5 mm"
    case .mm2_5:  return "2.5 mm"
    case .mm1:    return "1 mm"
    case .mm0_5:  return "0.5 mm"
    case .mm0_25: return "0.25 mm"
    case .mm0_1:  return "0.1 mm"
    }
  }

}
