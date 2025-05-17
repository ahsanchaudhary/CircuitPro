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
    
    var showAxes: Bool = true {
        didSet {
            (tiledLayer as? DottedLayer)?.showAxes = showAxes
            (tiledLayer as? GridLayer)?.showAxes = showAxes
        }
    }
    
    var gridSpacing: CGFloat = 10 {
        didSet {
            if let dotted = tiledLayer as? DottedLayer {
                dotted.unitSpacing = gridSpacing
            } else if let grid = tiledLayer as? GridLayer {
                grid.unitSpacing = gridSpacing
            }
        }
    }

    var magnification: CGFloat = 1.0 {
        didSet {
            let scale = max(magnification, 1.0) // Clamp: only shrink dots when zoomed in
            if let dotted = tiledLayer as? DottedLayer {
                dotted.dotRadius = baseDotRadius / scale
            }
        }
    }

    private let baseDotRadius: CGFloat = 1.0


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
