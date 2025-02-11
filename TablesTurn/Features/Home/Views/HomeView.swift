import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var formattedDate: (day: String, date: String) {
        let date = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        return (dayFormatter.string(from: date), dateFormatter.string(from: date))
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                LinearGradient(
                    gradient: Gradient(colors: [.secondaryBackground, .accentColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(alignment: .top) {
                            Image("LogoImage")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Tables Turn")
                                .font(.title2)
                        }
                        
                        HStack {
                            VStack {
                                Text(formattedDate.day)
                                    .font(.system(size: 35))
                                    .fontWeight(.semibold)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(formattedDate.date)
                                    .font(.system(size: 35))
                                    .fontWeight(.semibold)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 10) {
                                if viewModel.userDetails?.profileImage != nil {
                                    AsyncImage(url: URL(string: viewModel.userDetails?.profileImage ?? "")) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 40, height: 40, alignment: .center)
                                                .clipShape(Circle())
                                        } else if phase.error != nil {
                                            Color.red
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        } else {
                                            Color.gray
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                } else {
                                    Image("ProfileAvatar")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                
                                HStack(spacing: 3) {
                                    Image(systemName: "location.fill")
                                    Text("location")
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Button("Today".uppercased()) {}
                                        .buttonStyle(MainButtonStyle(
                                            maxWidth: 80,
                                            padding: 12,
                                            fontSize: 13,
                                            cornerRadius: 30,
                                            backgroundColor: .black,
                                            foregroundColor: .white,
                                            borderColor: .black,
                                            borderWidth: 2
                                        ))
                                    
                                    Button("Calendar".uppercased()) {
                                        UserManager.shared.logout()
                                    }
                                    .buttonStyle(MainButtonStyle(
                                        maxWidth: 80,
                                        padding: 12,
                                        fontSize: 13,
                                        cornerRadius: 30,
                                        backgroundColor: .clear,
                                        foregroundColor: .white,
                                        borderColor: .white,
                                        borderWidth: 2
                                    ))
                                }
                                
                                HStack {
                                    CustomTextField(
                                        placeholder: "Search Event",
                                        text: $viewModel.searchKey,
                                        isSecure: false,
                                        keyboardType: .default,
                                        iconName: "lock",
                                        backgroundColor: Color.inputField,
                                        borderColor: .black,
                                        iconColor: .black,
                                        textColor: .black,
                                        placeHolderColor: .black,
                                        validation: { input in
                                            if input.isEmpty {
                                                return "Password cannot be empty."
                                            }
                                            return nil
                                        }
                                    )
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 15) {
                                NavigationLink(destination: AddEventView()) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 20))
                                }
                                .buttonStyle(CircularButtonStyle(
                                    size: 50,
                                    foregroundColor: .black
                                ))
                                
                                Button(action: {}) {
                                    Image(systemName: "gear")
                                        .font(.system(size: 20))
                                }
                                .buttonStyle(CircularButtonStyle(
                                    size: 50,
                                    foregroundColor: .black
                                ))
                            }
                            .frame(maxWidth: 50, alignment: .trailing)
                        }
                        
                        Text("Visit ")
                            .font(.system(size: 35)) +
                        Text("events")
                            .font(.system(size: 35, weight: .bold))
                        +
                        Text(" based on your interest")
                            .font(.system(size: 35))
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("All")
                                    .underline()
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }
                        }
                        
                        VStack(spacing: 20) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(height: 230)
                            } else if viewModel.events.isEmpty {
                                Text("No events found")
                                    .frame(height: 230)
                            } else {
                                ForEach(viewModel.events) { event in
                                    EventCard(event: event)
                                        .padding(.bottom, 20)
                                }
                            }
                        }
                        
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea()
                    .padding(20)
                }
                .frame(maxHeight: .infinity)
            }
            .foregroundStyle(.primaryText)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.getAllEvents()
            viewModel.getUserDetails()
        }
    }
}

#Preview {
    HomeView()
}
