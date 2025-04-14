
import SwiftUI
import SwiftData

@Model
final class Schematic {
    
    var title: String
    var data: Data
    
    var timestamps: Timestamps

    var design: Design?
    
    @Relationship(deleteRule: .cascade, inverse: \Net.schematic)
    var nets: [Net] = []

    init(title: String, data: Data, design: Design?) {
        self.title = title
        self.data = data
        self.design = design
        self.timestamps = Timestamps()
    }
}
