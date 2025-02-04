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
                            .font(.title)
                    }
                    
                    (
                        Text("Connect, Engage,")
                            .foregroundStyle(.accent)
                        + Text(" Bringing People Together")
                    )
                    .font(.system(size: 43))
                    .fontWeight(.medium)
                    
                    ImageCarousel(images: CarouselImages.allCases)
                    
                    Button("Get Started".uppercased()) {}
                        .buttonStyle(PrimaryButtonStyle())
                }
                .padding(30)
            }
            .padding(.top, 20)
        }
        .foregroundStyle(.primaryText)
    }
}

#Preview {
    GettingStartedView()
}
