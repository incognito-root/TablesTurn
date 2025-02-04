import SwiftUI

enum CarouselImages: String, CaseIterable, Identifiable {
    case imageOne
    case imageTwo
    case imageThree
    case imageFour

    var id: UUID { UUID() }
    
    var imageName: String {
        switch self {
        case .imageOne:
            return "CarouselImage1"
        case .imageTwo:
            return "CarouselImage2"
        case .imageThree:
            return "CarouselImage3"
        case .imageFour:
            return "CarouselImage4"
        }
    }
}

struct ImageCarousel: View {
    let images: [CarouselImages]
    
    let pageWidth: CGFloat = 200
    let pageHeight: CGFloat = 300
    let spacing: CGFloat = 25
    
    @State private var xOffset: CGFloat = 0
    
    private var repeatedImages: [CarouselImages] {
        images + images
    }
    
    private var totalContentWidth: CGFloat {
        CGFloat(repeatedImages.count) * (pageWidth + spacing)
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: spacing) {
                ForEach(0..<repeatedImages.count, id: \.self) { index in
                    Image(repeatedImages[index].imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: pageWidth, height: pageHeight)
                        .clipped()
                        .cornerRadius(15)
                }
            }
            .offset(x: xOffset)
            .onAppear {
                let speed: CGFloat = 30.0
                let distance = totalContentWidth / 2
                let duration = Double(distance / speed)
                
                withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
                    xOffset = -distance
                }
            }
        }
        .frame(height: pageHeight)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCarousel(images: CarouselImages.allCases)
    }
}
