import SwiftUI
import SwiftData

import SwiftUI

struct SymbolView: View {
    let symbolInstance: SymbolInstance
    /// Now passed in by the parent.
    let primitives: [AnyPrimitive]

    var body: some View {
        ZStack {
          if primitives.isEmpty {
            Circle().frame(width:15, height:15)
          } else {
            ForEach(primitives) { $0.render() }
          }
        }
        .position(x: symbolInstance.position.x,
                  y: symbolInstance.position.y)
        .zIndex(10)
    }

}


// MARK: - Preview
//
//#Preview {
//    SymbolView(symbolInstance: SymbolInstance(symbolId: .init(), position: .init(x: 0, y: 0)))
//}
