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
                    LazyVStack(alignment: .leading, spacing: 20) {
                        HStack(alignment: .top) {
                            Image("LogoImage")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("Turns")
                                .font(.title2)
                        }
                        
                        HStack {
                            VStack {
                                Text(formattedDate.day)
                                    .font(.system(size: 35))
                                    .fontWeight(.semibold)
                                    .frame(width: 190, alignment: .leading)
                                Text(formattedDate.date)
                                    .font(.system(size: 35))
                                    .fontWeight(.semibold)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(width: 190, alignment: .leading)
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 10) {
                                Menu {
                                    NavigationLink("Tickets", destination: TicketsView())
                                    NavigationLink("Profile", destination: UserProfileView())
                                } label: {
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
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundStyle(Color.white)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                }
                                .menuStyle(BorderlessButtonMenuStyle()) // Remove the default menu styling
                                
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
                                    
                                    NavigationLink(destination: EventsCalendarView()) {
                                        ZStack {
                                            Text("CALENDAR")
                                                .font(.system(size: 13))
                                                .foregroundColor(.white)
                                        }
                                        .frame(maxWidth: 80)
                                        .padding(12)
                                        .background(Color.clear)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(Color.white, lineWidth: 2)
                                        )
                                        
                                    }
                                }
                                
                                HStack {
                                    CustomTextField(
                                        placeholder: "Search Event",
                                        text: $viewModel.searchKey,
                                        isSecure: false,
                                        keyboardType: .default,
                                        iconName: "magnifyingglass",
                                        backgroundColor: Color.inputField,
                                        borderColor: .white,
                                        iconColor: .white,
                                        textColor: .white,
                                        placeHolderColor: .white,
                                        validation: { _ in nil }
                                    )
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 15) {
                                NavigationLink(destination: AddEventView()) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 20))
                                        .foregroundStyle(Color.white)
                                    
                                }
                                .buttonStyle(CircularButtonStyle(
                                    size: 50,
                                    foregroundColor: .black
                                ))
                                
                                Button(action: {}) {
                                    Image(systemName: "gear")
                                        .font(.system(size: 20))
                                        .foregroundStyle(Color.white)
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
                                    .fontWeight(.bold)
                            }
                            
                            Spacer()
                            
                            PaginationView(currentPage: $viewModel.currentPage, totalPages: viewModel.totalPages)
                                .onChange(of: viewModel.currentPage) { _, _ in
                                    viewModel.getAllEvents()
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
                                    NavigationLink(destination: EventDetailsView(id: event.id)) {
                                        EventCard(event: event)
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.bottom, 20)
                                }
                            }
                        }
                        
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .ignoresSafeArea()
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                }
                .frame(maxHeight: .infinity)
                .refreshable {
                    viewModel.getAllEvents()
                }
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
            Task {
                viewModel.getAllEvents()
                await viewModel.getUserDetails()
            }
        }
    }
}

#Preview {
    HomeView()
}
