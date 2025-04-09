//
//  LayerHostingView.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 4/8/25.
//

import SwiftUI
import AppKit

// MARK: - Generic Layer Hosting Representable

/// A generic NSViewRepresentable that hosts a custom CALayer.
/// Use it to factor out common NSView setup logic.
struct LayerHostingRepresentable<LayerType: CALayer>: NSViewRepresentable {
    let frame: CGRect
    /// Closure that creates an instance of the custom layer.
    let createLayer: () -> LayerType
    /// Closure that updates the layer with external parameters.
    let updateLayer: (LayerType) -> Void

    func makeNSView(context: Context) -> NSView {
        let nsView = NSView(frame: frame)
        nsView.wantsLayer = true
        let layer = createLayer()
        layer.frame = frame
        layer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0
        nsView.layer = layer
        return nsView
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        if let layer = nsView.layer as? LayerType {
            updateLayer(layer)
            layer.setNeedsDisplay()
        }
    }
}
