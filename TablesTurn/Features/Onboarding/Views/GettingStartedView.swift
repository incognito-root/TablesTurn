import SwiftUI

struct GettingStartedView: View {
    let radius: CGFloat = 50;
    
    var body: some View {
        ZStack {
            Color.accentColor.ignoresSafeArea()
            
            ZStack(alignment: .topLeading) {
                Color.primaryBackground
                    .ignoresSafeArea()
                    .padding(.bottom, radius)
                    .cornerRadius(radius)
                    .padding(.bottom, -radius)
                
                VStack(alignment: .leading, spacing: 40) {
                    HStack {
                        Image("LogoImage")
                        Text("Tables Turn")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    }
                    
                    (
                        Text("Connect, Engage,")
                            .foregroundStyle(.accent)
                        + Text(" Bringing People Together")
                    )
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                }
                .padding(40)
                
                VStack {
                    ImageCarousel(images: CarouselImages.allCases)
                }
                .padding(.top, 250)
            }
            .padding(.top, 20)
        }
        .foregroundStyle(.primaryText)
    }
}

#Preview {
    GettingStartedView()
}
