import SwiftUI

struct ComponentDesignView: View {
    
    @Environment(\.componentDesignManager) private var componentDesignManager
    
    enum ComponentDesignStage: String, CaseIterable, Identifiable {
        case component = "Component Details"
        case symbol = "Symbol Creation"
        case footprint = "Footprint Creation"
        var id: String { self.rawValue }
    }
    
    @State private var currentStage: ComponentDesignStage = .component

    @State private var symbolCanvasManager = CanvasManager()
    @State private var footprintCanvasManager = CanvasManager()
    @State private var symbolScrollViewManager = ScrollViewManager()
    @State private var footprintScrollViewManager = ScrollViewManager()
    
    var body: some View {
        VStack {
            stageIndicator
            Spacer()
            StageContentView(
                left: {
                    switch currentStage {
                    case .symbol:
                        if componentDesignManager.allPins.isNotEmpty {
                            PinEditorView(
                                       pins: componentDesignManager.allPins,
                                       selectedPins: componentDesignManager.bindingForSelectedPins()
                                   )
                           
                            .transition(.move(edge: .trailing).combined(with: .blurReplace))
                            
                           
                            .padding()
                        } else {
                            Color.clear
                        }
          
                    case .footprint:
                        if componentDesignManager.allPads.isNotEmpty {
                            PadEditorView(
                                       pads: componentDesignManager.allPads,
                                       selectedPads: componentDesignManager.bindingForSelectedPads()
                                   )
                           
                            .transition(.move(edge: .trailing).combined(with: .blurReplace))
                            
                           
                            .padding()
                        } else {
                            Color.clear
                        }
                    default:
                        Color.clear
                    }
            
                },
                center: {
                    switch currentStage {
                    case .component:
                        ComponentDetailView()
                    case .symbol:
                        SymbolDesignView()
                            .environment(symbolCanvasManager)
                            .environment(symbolScrollViewManager)
                    case .footprint:
                        FootprintDesignView()
                            .environment(footprintCanvasManager)
                            .environment(footprintScrollViewManager)
                    }
                },
                right: {
                    switch currentStage {
                    case .footprint:
                        LayerTypeListView()
  
                        .transition(.move(edge: .leading).combined(with: .blurReplace))
                       
                       
                        .padding()
                    default:
                        Color.clear
                    }
               
                }
            )
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
           
                            currentStage = stage
                        
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
                .zIndex(0)
            center.frame(width: width, height: height)
                .zIndex(1)
            right.frame(width: sidebarWidth, height: height)
                .zIndex(0)
        }
    }
}


struct StageSidebarView<Header: View, Content: View>: View {
    
    @ViewBuilder
    let header: Header
    @ViewBuilder
    let content: Content

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                header
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .border(edge: .bottom, color: .gray.opacity(0.3))
            
            
    
                content
        
   
            
               
       
         
         
            
        }
        
        .frame(maxHeight: .infinity)
        .clipAndStroke(with: RoundedRectangle(cornerRadius: 15))

   
    }
    
}

