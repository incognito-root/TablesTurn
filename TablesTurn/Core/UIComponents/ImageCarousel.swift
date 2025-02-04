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
            "CarouselImage1"
        case .imageTwo:
            "CarouselImage2"
        case .imageThree:
            "CarouselImage3"
        case .imageFour:
            "CarouselImage4"
        }
    }
}

struct ImageCarousel: View {
    
    let images: [CarouselImages]
    
    @State var scrollPosition: Int?
    @State var itemsArray: [[CarouselImages]] = []
    @State var autoScrollEnabled: Bool = true
    let pageWidth: CGFloat = 250
    let pageHeight: CGFloat = 350
    let animationDuration: CGFloat = 0.3
    let secondsPerSlide: CGFloat = 1.0
    let animation: Animation = .default
    
    var body: some View {
        let itemsTemp = itemsArray.flatMap { $0.map { $0 } }
        let widthDifference = UIScreen.main.bounds.width - pageWidth
        
        VStack(spacing: 20) {
//            Button(action: {
//                let isEnabled = autoScrollEnabled
//                autoScrollEnabled.toggle()
//                if !isEnabled {
//                    guard let scrollPosition = scrollPosition else {return}
//                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
//                        withAnimation(animation) {
//                            self.scrollPosition = scrollPosition + 1
//                        }
//                    })
//                }
//            }, label: {
//                Text(autoScrollEnabled ? "Stop" : "Start")
//                    .padding()
//                    .foregroundStyle(.white)
//                    .background(RoundedRectangle(cornerRadius: 16).fill(.black))
//            })
            
            ScrollView(.horizontal) {
                HStack(spacing: 25) {
                    ForEach(0..<itemsTemp.count, id: \.self) { index in
                        let item = itemsTemp[index]
                        
                        Image(item.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: pageWidth, height: pageHeight)
                            .clipped()
                            .cornerRadius(15)
                            .scrollTransition { content, phase in
                                content
//                                    .scaleEffect(y: phase.isIdentity ? 1 : 0.7)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(widthDifference/2, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .frame(height: pageHeight * 1.3)
            .scrollPosition(id: $scrollPosition, anchor: .center)
            .scrollIndicators(.hidden)
            .onAppear {
                self.itemsArray = [images, images, images]
                scrollPosition = images.count
            }
            .onChange(of: scrollPosition) {
                guard let scrollPosition = scrollPosition else {return}
                print(scrollPosition)
                
                let itemCount = images.count
                if scrollPosition / itemCount == 0 && scrollPosition % itemCount == itemCount - 1  {
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                        itemsArray.removeLast()
                        itemsArray.insert(images, at: 0)
                        self.scrollPosition = scrollPosition + images.count
                    }
                    return
                }
                
                if scrollPosition / itemCount == 2 && scrollPosition % itemCount == 0  {
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                        itemsArray.removeFirst()
                        itemsArray.append(images)
                        self.scrollPosition = scrollPosition - images.count
                    }
                    
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsPerSlide, execute: {
                    if autoScrollEnabled {
                        withAnimation(animation) {
                            self.scrollPosition = scrollPosition + 1
                        }
                    }
                })
            }
            
//            HStack {
//                ForEach(0..<images.count, id: \.self) { index in
//                    Button(action: {
//                        withAnimation(animation) {
//                            scrollPosition = index + images.count
//                        }
//                    }, label: {
//                        Circle()
//                            .fill(Color.gray.opacity(
//                                (index == (scrollPosition ?? 0) % images.count) ? 0.8 : 0.3
//                            ))
//                            .frame(width: 15)
//                    })
//                }
//            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCarousel(images: CarouselImages.allCases)
    }
}
