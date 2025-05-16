// Pin+Rendering.swift
import AppKit

private let haloThickness: CGFloat = 4          // keep all magic numbers in one place

extension Pin {

    /// Draws the pin: primitives → optional halo → optional text.
    func draw(in ctx: CGContext,
              showText: Bool = true,
              highlight: Bool = false)
    {
        // ───────────────────────────────────────────── 1. primitives
        // Paint each sub-primitive with its own ink (no per-primitive halos).
        for prim in primitives {
            prim.draw(in: ctx, selected: false)
        }

        // ───────────────────────────────────────────── 2. unified halo
        if highlight {
            let haloPath = CGMutablePath()

            for prim in primitives {
                let stroked = prim.makePath()                // geometry of the primitive
                    .copy(strokingWithWidth : haloThickness,  // expand to filled outline
                          lineCap           : .round,
                          lineJoin          : .round,
                          miterLimit        : 10)

                haloPath.addPath(stroked)                    // accumulate
            }

            ctx.saveGState()
            ctx.addPath(haloPath)
            ctx.setFillColor(NSColor.systemBlue
                                .withAlphaComponent(0.4).cgColor)
            ctx.fillPath()                                   // one fill → no seams
            ctx.restoreGState()
        }

        // ───────────────────────────────────────────── 3. text
        guard showText else { return }

        let font     = NSFont.systemFont(ofSize: 10)
        let legStart = CGPoint(x: position.x - length, y: position.y)

        // Number above the leg
        let numberPos = CGPoint(
            x: legStart.x + (length - "\(number)".size(withAttributes: [.font: font]).width) / 2,
            y: legStart.y - font.pointSize - 3
        )
        drawAttributedText("\(number)",
                           font: font,
                           color: .systemBlue,
                           isSelected: highlight,
                           at: numberPos,
                           context: ctx)

        // Label left of the pad
        let labelSize = name.size(withAttributes: [.font: font])
        let labelPos  = CGPoint(
            x: legStart.x - labelSize.width - 6,
            y: legStart.y - labelSize.height / 2
        )
        drawAttributedText(name,
                           font: font,
                           color: .systemBlue,
                           isSelected: highlight,
                           at: labelPos,
                           context: ctx)
    }
}

// MARK: - Tiny helper used for both number & label
private func drawAttributedText(_ string: String,
                                font: NSFont,
                                color: NSColor,
                                isSelected: Bool,
                                at origin: CGPoint,
                                context ctx: CGContext)
{
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center

    var attrs: [NSAttributedString.Key : Any] = [
        .font            : font,
        .foregroundColor : color,
        .paragraphStyle  : paragraph
    ]
    if isSelected {
        attrs[.strokeColor] = NSColor.systemBlue.withAlphaComponent(0.4)
        attrs[.strokeWidth] = -10        // negative → stroke *and* fill
    }

    let str = NSAttributedString(string: string, attributes: attrs)

    ctx.saveGState()
    str.draw(at: origin)
    ctx.restoreGState()
}

// Pin+HitRects.swift
import AppKit

extension Pin {

    /// Returns the label & number rectangles in *canvas coordinates*.
    func textHitRects(font: NSFont = .systemFont(ofSize: 10)) -> (number: CGRect, label: CGRect) {

        let legMid = CGPoint(x: position.x - length / 2, y: position.y)

        // --- number (above leg) ------------------------------------------
        let numSize = "\(number)".size(withAttributes: [.font: font])
        let numPos  = CGPoint(x: legMid.x - numSize.width / 2,
                              y: legMid.y - numSize.height - 3)
        let numRect = CGRect(origin: numPos, size: numSize)

        // --- label (left of pad) -----------------------------------------
        let lblSize = name.size(withAttributes: [.font: font])
        let lblPos  = CGPoint(x: position.x - length - 6 - lblSize.width,
                              y: position.y - lblSize.height / 2)
        let lblRect = CGRect(origin: lblPos, size: lblSize)

        return (number: numRect, label: lblRect)
    }
}

