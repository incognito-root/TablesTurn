import SwiftUI

fileprivate enum CarouselImages: String, CaseIterable, Identifiable {
    case red
    case blue
    case orange
    case purple

    var id: UUID { UUID() }
    
    var color: Color {
        switch self {
        case .red:
            Color.red
        case .blue:
            Color.blue
        case .orange:
            Color.orange
        case .purple:
            Color.purple
        }
    }
}

struct ImageCarousel: View {
    
    private let images: [Image] = [Image("CarouselImage1"), Image("CarouselImage2"), Image("CarouselImage3")]
    
    @State private var scrollPosition: Int?
    @State private var itemsArray: [[Image]] = []
    @State private var autoScrollEnabled: Bool = false
    private let pageWidth: CGFloat = 250
    private let pageHeight: CGFloat = 350
    private let animationDuration: CGFloat = 0.3
    private let secondsPerSlide: CGFloat = 1.0
    private let animation: Animation = .default
    
    var body: some View {
        let itemsTemp = itemsArray.flatMap { $0.map { $0 } }
        let widthDifference = UIScreen.main.bounds.width - pageWidth
        
        VStack(spacing: 20) {
            Button(action: {
                let isEnabled = autoScrollEnabled
                autoScrollEnabled.toggle()
                // going from false to true
                if !isEnabled {
                    guard let scrollPosition = scrollPosition else {return}
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        withAnimation(animation) {
                            self.scrollPosition = scrollPosition + 1
                        }
                    })
                }
            }, label: {
                Text(autoScrollEnabled ? "Stop" : "Start")
                    .padding()
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 16).fill(.black))
            })
            
            ScrollView(.horizontal) {
                HStack(spacing: 25) {
                    ForEach(0..<itemsTemp.count, id: \.self) { index in
                        let item = itemsTemp[index]
                        
                        Text(item.rawValue)
                            .foregroundStyle(.black)
                            .font(.system(size: 24, weight: .bold))
                            .frame(width: pageWidth, height: 360)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(item.color)
                            )
                            .scrollTransition{ content, phase in
                                content
                                    .scaleEffect(y: phase.isIdentity ? 1 : 0.7)
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
                // start at the first item of the second colors array
                scrollPosition = images.count
            }
            .onChange(of: scrollPosition) {
                guard let scrollPosition = scrollPosition else {return}
                print(scrollPosition)
                
                let itemCount = images.count
                // last item of the first colors Array
                if scrollPosition / itemCount == 0 && scrollPosition % itemCount == itemCount - 1  {
                    print("last item of the first colors")
                    // append colors array before the first and remove the curren last color array
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                        itemsArray.removeLast()
                        itemsArray.insert(images, at: 0)
                        self.scrollPosition = scrollPosition + images.count
                    }
                    return
                }
                
                // first item of the last colors Array
                if scrollPosition / itemCount == 2 && scrollPosition % itemCount == 0  {
                    print("first item of the last colors")
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
            
            HStack {
                ForEach(0..<images.count, id: \.self) { index in
                    Button(action: {
                        withAnimation(animation) {
                            scrollPosition = index + images.count
                        }
                    }, label: {
                        Circle()
                            .fill(Color.gray.opacity(
                                (index == (scrollPosition ?? 0) % images.count) ? 0.8 : 0.3
                            ))
                            .frame(width: 15)
                    })
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCarousel()
    }
}
