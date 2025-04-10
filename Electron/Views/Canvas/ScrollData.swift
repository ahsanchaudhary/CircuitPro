//
//  ScrollData.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/5/25.
//

import SwiftUI


struct ScrollData: Equatable {
let contentOffset: CGPoint
let contentSize: CGSize
let contentInsets: EdgeInsets
let containerSize: CGSize
let bounds: CGRect
let visibleRect: CGRect

static let empty = ScrollData(
    contentOffset: .zero,
    contentSize: .zero,
    contentInsets: EdgeInsets(),
    containerSize: .zero,
    bounds: .zero,
    visibleRect: .zero
)}
