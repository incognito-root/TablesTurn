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
    
    init() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
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
                                    NavigationLink(destination: UserProfileView()) {
                                        Label("Profile", systemImage: "person.crop.circle")
                                    }
                                    NavigationLink(destination: UserEventsView()) {
                                        Label("Hosted Events", systemImage: "party.popper")
                                    }
                                    NavigationLink(destination: TicketsView()) {
                                        Label("My Tickets", systemImage: "ticket.fill")
                                    }
                                    NavigationLink(destination: RedeemTicketView()) {
                                        Label("Redeem Ticket", systemImage: "qrcode.viewfinder")
                                    }
                                    Button {
                                        UserManager.shared.logout()
                                    } label: {
                                        Label("Logout", systemImage: "arrowshape.turn.up.left")
                                    }
                                    
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
                                    NavigationLink(destination: TodaysEventsView()) {
                                        Text("TODAY")
                                            .font(.system(size: 13))
                                            .foregroundColor(.white)
                                            .padding(12)
                                            .frame(width: 100)
                                            .background(Color.black)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 30)
                                                    .stroke(Color.black, lineWidth: 2)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 30))
                                    }
                                    
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
                                
                                NavigationLink(destination: AccountSettingsView()) {
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
                        }
                        
                        VStack(spacing: 20) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .frame(height: 230)
                                    .background(Color.clear)
                                    .padding(.vertical, 20)
                            } else if viewModel.events.isEmpty {
                                Text("No events found")
                                    .frame(height: 230)
                                    .frame(maxWidth: .infinity)
                                    .font(.system(size: 30))
                                    .foregroundStyle(Color.white)
                            } else {
                                ForEach(viewModel.events) { event in
                                    NavigationLink(destination: EventDetailsView(id: event.id)) {
                                        EventCard(event: event)
                                    }
                                    .buttonStyle(.plain)
                                    .padding(.bottom, 20)
                                    .onAppear {
                                        if event.id == viewModel.events.last?.id {
                                            viewModel.loadMoreEvents()
                                        }
                                    }
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
