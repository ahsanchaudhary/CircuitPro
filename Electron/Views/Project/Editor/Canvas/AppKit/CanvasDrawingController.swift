//  CanvasDrawingController.swift
import AppKit

final class CanvasDrawingController {

    unowned let canvas: CoreGraphicsCanvasView
    init(canvas: CoreGraphicsCanvasView) { self.canvas = canvas }

    // ---------------------------------------------------------------- draw
    func draw(in ctx: CGContext, dirtyRect: NSRect) {
        drawElements(in: ctx)
        drawLivePreview(in: ctx)
        drawHandles(in: ctx)
        drawMarquee(in: ctx)

    }

    // MARK: - 1 elements + hit rects
    private func drawElements(in ctx: CGContext) {
        for element in canvas.elements {
            let selected = canvas.selectedIDs.contains(element.id)
            element.draw(in: ctx, selected: selected)

            if case let .pin(pin) = element {
                cacheHitRects(for: pin)
            }
        }
    }

    private func cacheHitRects(for pin: Pin) {
        let rects = pin.textHitRects()
        canvas.hitRects.pinNumberRects[pin.id] = rects.number
        canvas.hitRects.pinLabelRects[pin.id]  = rects.label
    }

    // MARK: - 2 live preview for the active tool
    private func drawLivePreview(in ctx: CGContext) {
        guard var tool = canvas.selectedTool,
              tool.id != "cursor",
              let win  = canvas.window else { return }

        let mouseWin = win.mouseLocationOutsideOfEventStream
        let mouse    = canvas.convert(mouseWin, from: nil)

        let pinCount = canvas.elements.reduce(0) { $1.isPin ? $0 + 1 : $0 }
        let ctxInfo  = CanvasToolContext(existingPinCount: pinCount)

        let snappedMouse = canvas.snap(mouse)
        tool.drawPreview(in: ctx, mouse: snappedMouse, context: ctxInfo)

        canvas.selectedTool = tool               // persist mutated state
    }

    // MARK: - 3 selection handles
    private func drawHandles(in ctx: CGContext) {
        guard canvas.selectedIDs.count == 1 else { return }

        ctx.setFillColor(NSColor(.white).cgColor)
        ctx.setStrokeColor(NSColor(.blue).cgColor)
        ctx.setLineWidth(1)

        let size: CGFloat = 6, half = size / 2

        for element in canvas.elements
        where canvas.selectedIDs.contains(element.id) && element.isPrimitiveEditable {

            for h in element.handles() {
                let r = CGRect(x: h.position.x - half,
                               y: h.position.y - half,
                               width: size,
                               height: size)
                ctx.fillEllipse(in: r)
                ctx.strokeEllipse(in: r)
            }
        }
    }
    
    // MARK: - 4 maruquee box
    private func drawMarquee(in ctx: CGContext) {
        guard let rect = canvas.marqueeRect else { return }


        ctx.saveGState()
        ctx.setStrokeColor(NSColor(.blue).cgColor)
        ctx.setFillColor(NSColor(.blue.opacity(0.1)).cgColor)
        ctx.setLineWidth(1)
        ctx.setLineDash(phase: 0, lengths: [4, 2])
        ctx.stroke(rect)
        ctx.fill(rect)
        ctx.restoreGState()
    }

}
