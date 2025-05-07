//
//  TextShape.swift
//  Electron
//
//  Created by Giorgi Tchelidze on 5/3/25.
//



import SwiftUI
@preconcurrency import CoreText

enum TextAlignment {
    case leading
    case center
    case trailing
}

struct TextShape: Shape {
    let text: String
    let ctFont: CTFont
    let alignment: TextAlignment
    private let cachedPath: Path
    private let bounds: CGRect

    init(text: String, font: CTFont? = nil, alignment: TextAlignment = .center) {
        self.text = text
        self.alignment = alignment
        // Use passed font or system as fallback
        let bodyFont: CTFont = font ?? {
            #if os(macOS)
            let ns = NSFont.preferredFont(forTextStyle: .body)
            return CTFontCreateWithName("System Font" as CFString, ns.pointSize, nil)
            #else
            let uiFont = UIFont.preferredFont(forTextStyle: .body)
            return CTFontCreateWithName(uiFont.fontName as CFString, uiFont.pointSize, nil)
            #endif
        }()
        self.ctFont = bodyFont
        let path = TextShape.makePath(text: text, font: bodyFont)
        self.cachedPath = path
        self.bounds = path.boundingRect
    }

    func path(in rect: CGRect) -> Path {
        let tx: CGFloat
        switch alignment {
        case .leading:
            tx = rect.minX - bounds.minX
        case .center:
            tx = rect.midX - bounds.midX
        case .trailing:
            tx = rect.maxX - bounds.maxX
        }
        let ty = rect.midY + bounds.height / 2
        var transform = CGAffineTransform(translationX: tx, y: ty).scaledBy(x: 1, y: -1)
        guard let cgpath = cachedPath.cgPath.copy(using: &transform) else {
            return Path()
        }
        return Path(cgpath)
    }

    private static func makePath(text: String, font: CTFont) -> Path {
        guard !text.isEmpty else { return Path() }
        let attr = NSAttributedString(string: text, attributes: [.font: font])
        let line = CTLineCreateWithAttributedString(attr)
        let glyphRuns = CTLineGetGlyphRuns(line) as NSArray
        let mpath = CGMutablePath()

        for runObj in glyphRuns {
            // Defensive: check CFTypeID to avoid conditional downcast warnings and potential crash
            if CFGetTypeID(runObj as CFTypeRef) == CTRunGetTypeID() {
                let run = runObj as! CTRun
                let runAttributes = CTRunGetAttributes(run) as NSDictionary
                // Defensive: explicitly force-cast, as per Swift conventions for CoreFoundation bridge
                let runFont = runAttributes[kCTFontAttributeName] as! CTFont
                let count = CTRunGetGlyphCount(run)
                var glyphs = [CGGlyph](repeating: 0, count: count)
                var positions = [CGPoint](repeating: .zero, count: count)
                CTRunGetGlyphs(run, CFRange(), &glyphs)
                CTRunGetPositions(run, CFRange(), &positions)
                for i in 0..<count {
                    if let gpath = CTFontCreatePathForGlyph(runFont, glyphs[i], nil) {
                        let t = CGAffineTransform(translationX: positions[i].x, y: positions[i].y)
                        mpath.addPath(gpath, transform: t)
                    }
                }
            } else {
                print("Warning: Non-CTRun found in glyphRuns: \(runObj)")
            }
        }
        return Path(mpath)
    }
}
