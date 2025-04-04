import SwiftUI
import AppKit

struct DottedLayerView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true

        let tiledLayer = TiledDottedLayer()
        tiledLayer.tileSize = CGSize(width: 256, height: 256)
        tiledLayer.levelsOfDetail = 4
        tiledLayer.levelsOfDetailBias = 4
        tiledLayer.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0
        tiledLayer.frame = CGRect(origin: .zero, size: CGSize(width: 3000, height: 3000))

        view.frame = tiledLayer.frame
        view.layer = tiledLayer
        context.coordinator.layer = tiledLayer

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // ⛔️ DO NOT update the frame or redraw here right now
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var layer: TiledDottedLayer?
    }
}



class TiledDottedLayer: CATiledLayer {
    override class func fadeDuration() -> CFTimeInterval { 0.0 } // no fade

    override func draw(in ctx: CGContext) {
        let tileRect = ctx.boundingBoxOfClipPath
        let dotSpacing: CGFloat = 20
        let dotRadius: CGFloat = 1
        let majorEvery: Int = 10

        // Figure out which dots belong in this tile
        let minX = Int(tileRect.minX / dotSpacing)
        let maxX = Int(tileRect.maxX / dotSpacing)
        let minY = Int(tileRect.minY / dotSpacing)
        let maxY = Int(tileRect.maxY / dotSpacing)

        for x in minX...maxX {
            for y in minY...maxY {
                let px = CGFloat(x) * dotSpacing
                let py = CGFloat(y) * dotSpacing
                let isMajor = (x % majorEvery == 0) || (y % majorEvery == 0)
                let color = NSColor.gray.withAlphaComponent(isMajor ? 0.7 : 0.3).cgColor

                ctx.setFillColor(color)
                ctx.fillEllipse(in: CGRect(
                    x: px - dotRadius,
                    y: py - dotRadius,
                    width: dotRadius * 2,
                    height: dotRadius * 2
                ))
            }
        }
    }
}


#Preview {
    DottedLayerView()
}
