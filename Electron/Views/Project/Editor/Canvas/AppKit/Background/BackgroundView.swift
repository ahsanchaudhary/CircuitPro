//
//  BackgroundView.swift
//  Electron_Tests
//
//  Created by Giorgi Tchelidze on 5/16/25.
//
import AppKit

final class BackgroundView: NSView {

    // MARK: – Public
    var currentStyle: CanvasBackgroundStyle = .dotted {
        didSet { rebuildLayer() }
    }

    // MARK: – Private
    private var tiledLayer: CALayer?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        rebuildLayer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        wantsLayer = true
        rebuildLayer()
    }

    override func layout() {
        super.layout()
        tiledLayer?.frame = bounds
        tiledLayer?.setNeedsDisplay()
    }

    private func rebuildLayer() {
        tiledLayer?.removeFromSuperlayer()

        let layer: CALayer = {
            switch currentStyle {
            case .dotted:
                let l = DottedLayer()
                l.unitSpacing   = 10
                l.dotRadius     = 1
                l.axisLineWidth = 1
                l.showAxes      = true
                return l
            case .grid:
                let l = GridLayer()
                l.unitSpacing   = 10
                l.lineWidth     = 0.5
                l.axisLineWidth = 1
                l.showAxes      = true
                return l
            }
        }()

        layer.frame         = bounds
        layer.contentsScale = window?.backingScaleFactor
                             ?? NSScreen.main?.backingScaleFactor
                             ?? 2
        self.layer?.addSublayer(layer)
        tiledLayer = layer
    }
}
