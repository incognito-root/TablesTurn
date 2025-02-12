import SwiftUI

struct GettingStartedView: View {
    let radius: CGFloat = 50;
    
    var body: some View {
        NavigationStack {
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
                        
                        VStack {
                            NavigationLink(destination: SignupFormView()) {
                                Text("GET STARTED")
                                    .frame(maxWidth: .infinity)
                                    .padding(12)
                                    .padding(.bottom, 0)
                                    .font(.system(size: 25))
                                    .foregroundStyle(.black)
                                    .background(
                                        RoundedRectangle(cornerRadius: 50)
                                            .fill(Color.accentColor)
                                    )
                            }
                            
                            NavigationLink(destination: LoginFormView()) {
                                Text("ALREADY HAVE AN ACCOUNT")
                                    .frame(maxWidth: .infinity)
                                    .padding(.top, 15)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding(EdgeInsets(top: 30, leading: 30, bottom: 0, trailing: 30))
                }
                .padding(.top, 20)
            }
            .foregroundStyle(.primaryText)
        }
    }
}

#Preview {
    GettingStartedView()
}
