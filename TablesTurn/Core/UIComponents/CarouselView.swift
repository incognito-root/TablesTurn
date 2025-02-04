import SwiftUI

enum DragState: Equatable {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

struct Carousel<Content: View>: View {
    @GestureState private var dragState = DragState.inactive
    @State private var carouselLocation = 0
    
    // Parameters which we will pass when calling the CarouselView
    var itemHeight: CGFloat
    var views: [Content]
    
    private func onDragEnded(drag: DragGesture.Value) {
        let dragThreshold: CGFloat = 200
        if drag.predictedEndTranslation.width > dragThreshold || drag.translation.width > dragThreshold {
            carouselLocation = (carouselLocation - 1 + views.count) % views.count
        } else if drag.predictedEndTranslation.width < (-1 * dragThreshold) || drag.translation.width < (-1 * dragThreshold) {
            carouselLocation = (carouselLocation + 1) % views.count
        }
    }
    
    private func relativeLoc() -> Int {
        return ((views.count * 10000) + carouselLocation) % views.count
    }
    
    private func getOffset(_ index: Int) -> CGFloat {
        let relativeLocation = relativeLoc()
        let offset = index - relativeLocation
        return CGFloat(offset) * (300 + 20) + dragState.translation.width
    }
    
    private func getHeight(_ index: Int) -> CGFloat {
        return index == relativeLoc() ? itemHeight : itemHeight - 100
    }
    
    private func getOpacity(_ index: Int) -> Double {
        let relativeLocation = relativeLoc()
        let difference = abs(index - relativeLocation)
        return difference <= 2 ? 1 : 0
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<views.count, id: \.self) { index in
                views[index]
                    .frame(width: 300, height: getHeight(index))
                    .background(Color.white)
                    .cornerRadius(15)
                    .opacity(getOpacity(index))
                    .offset(x: getOffset(index))
                    .animation(.interpolatingSpring(stiffness: 300, damping: 30, initialVelocity: 10), value: dragState)
            }
        }
        .gesture(
            DragGesture()
                .updating($dragState) { drag, state, _ in
                    state = .dragging(translation: drag.translation)
                }
                .onEnded(onDragEnded)
        )
    }
}

struct CarouselView: View {
    var body: some View {
        Carousel(itemHeight: 300, views: [
            Image("CarousalImage1"),
            Image("CarouselImage2"),
            Image("CarouselImage3"),
            Image("CarouselImage4")
        ])
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
    }
}
