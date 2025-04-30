import SwiftUI

struct ComponentDesignView: View {
    enum ComponentDesignStage: String, CaseIterable, Identifiable {
        case component = "Component Data"
        case symbol = "Symbol Creation"
        case footprint = "Footprint Creation"
        var id: String { self.rawValue }
    }
    
    @State private var currentStage: ComponentDesignStage = .component
    @State private var tempPin: Pin = Pin(number: 1, position: SDPoint(.zero), type: .unknown, lengthType: .long)
    
    var body: some View {
        VStack {
            stageIndicator
            Spacer()
            StageContentView(
                left: {
                    if currentStage == .symbol {
                        PinPropertiesView(pin: $tempPin)
                            .padding()
                    } else {
                        Color.clear
                    }
                },
                center: {
                    switch currentStage {
                    case .component:
                        ComponentDetailView()
                    case .symbol:
                        SymbolDesignView()
                    case .footprint:
                        Text("Footprint Design")
                    }
                },
                right: {
                    Color.clear // actual right sidebar if/when needed
                }
            )
            .disableAnimations()
            Spacer()
        }
        .padding()
        
        .navigationTitle("Component Designer")
    }
    
    var stageIndicator: some View {
        HStack {
            ForEach(ComponentDesignStage.allCases) { stage in
                Text(stage.rawValue)
                    .padding(10)
                    .background(currentStage == stage ? .blue : .clear)
                    .foregroundStyle(currentStage == stage ? .white : .secondary)
                    .clipShape(.capsule)
                    .onTapGesture {
                        withAnimation {
                            currentStage = stage
                        }
                    }
                if stage == .component || stage == .symbol {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .font(.headline)
        .padding()
    }
}

struct PinPropertiesView: View {
    
    @Binding var pin: Pin
    
    var body: some View {
        
        Form {
            Section("Pin Properties") {
            IntegerField(title: "Number", value: $pin.number)
              
       

                Picker("Pin Function", selection: $pin.type) {
                    ForEach(PinType.allCases) { pinType in
                        
                        Text(pinType.label).tag(pinType)
                        
                        
                    }
                }
                Picker("Pin Length", selection: $pin.lengthType) {
                    ForEach(PinLengthType.allCases) { pinLengthType in
                        Text(pinLengthType.rawValue.capitalized).tag(pinLengthType)
                    }
                }
            }
            
            
        }
        .formStyle(.grouped)
        .listStyle(.inset)
        .clipAndStroke(with: RoundedRectangle(cornerRadius: 15))
        
        
    }
}




private struct StageContentView<Left: View, Center: View, Right: View>: View {
    let left: Left
    let center: Center
    let right: Right
    let width: CGFloat
    let height: CGFloat
    let sidebarWidth: CGFloat
    
    init(width: CGFloat = 800, height: CGFloat = 500, sidebarWidth: CGFloat = 325,
         @ViewBuilder left: () -> Left,
         @ViewBuilder center: () -> Center,
         @ViewBuilder right: () -> Right) {
        self.left = left()
        self.center = center()
        self.right = right()
        self.width = width
        self.height = height
        self.sidebarWidth = sidebarWidth
    }
    
    var body: some View {
        HStack(spacing: 0) {
            left.frame(width: sidebarWidth, height: height)
            center.frame(width: width, height: height)
            right.frame(width: sidebarWidth, height: height)
        }
    }
}
