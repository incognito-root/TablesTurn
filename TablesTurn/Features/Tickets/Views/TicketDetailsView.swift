import SwiftUI

struct TicketDetailsView: View {
    let radius: CGFloat = 50
    
    @StateObject var viewModel: TicketsViewModel
    
    init(vm: TicketsViewModel) {
        _viewModel = StateObject(wrappedValue: vm)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(Color.clear)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.secondaryBackground, .accentColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ZStack(alignment: .topLeading) {
                    Color.primaryBackground
                        .ignoresSafeArea()
                        .padding(.bottom, radius)
                        .cornerRadius(radius)
                        .padding(.bottom, -radius)
                    
                    VStack(spacing: 0) {
                        Form {
                            Section {
                                HStack {
                                    Spacer()
                                    AsyncImage(url: URL(string: viewModel.ticketDetails?.users.profileImage ?? "")) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "person.circle.fill")
                                                .resizable()
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                            }
                            
                            Section(header: Text("Ticket Information").font(.headline).fontWeight(.bold)) {
                                HStack {
                                    Text("Ticket ID")
                                    Spacer()
                                    Text(viewModel.ticketDetails?.ticketId ?? "N/A")
                                        .foregroundColor(.gray)
                                }
                                
                                HStack {
                                    Text("Redeemed")
                                    Spacer()
                                    Text(viewModel.ticketDetails?.redeemed == true ? "Yes" : "No")
                                        .foregroundColor(.gray)
                                }
                                
                                HStack {
                                    Text("Redeemed At")
                                    Spacer()
                                    if let redeemedDate = viewModel.ticketDetails?.redeemedAt {
                                        Text(redeemedDate, style: .date)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text("N/A")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                            
                            Section(header: Text("User Information").font(.headline).fontWeight(.bold)) {
                                HStack {
                                    Text("First Name")
                                    Spacer()
                                    Text(viewModel.ticketDetails?.users.firstName ?? "N/A")
                                        .foregroundColor(.gray)
                                }
                                
                                HStack {
                                    Text("Last Name")
                                    Spacer()
                                    Text(viewModel.ticketDetails?.users.lastName ?? "N/A")
                                        .foregroundColor(.gray)
                                }
                                
                                HStack {
                                    Text("Instagram")
                                    Spacer()
                                    Text(viewModel.ticketDetails?.users.instagramUsername ?? "N/A")
                                        .foregroundColor(.gray)
                                }
                                
                                HStack {
                                    Text("Twitter")
                                    Spacer()
                                    Text(viewModel.ticketDetails?.users.twitterUsername ?? "N/A")
                                        .foregroundColor(.gray)
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                            
                            Section(header: Text("Event Information").font(.headline).fontWeight(.bold)) {
                                HStack {
                                    Text("Event Title")
                                    Spacer()
                                    Text(viewModel.ticketDetails?.events.title ?? "N/A")
                                        .foregroundColor(.gray)
                                }
                                
                                HStack {
                                    Text("Location")
                                    Spacer()
                                    Text(viewModel.ticketDetails?.events.location ?? "N/A")
                                        .foregroundColor(.gray)
                                }
                                
                                HStack {
                                    Text("Redeemed At")
                                    Spacer()
                                    if let redeemedDate = viewModel.ticketDetails?.events.dateTime {
                                        Text(redeemedDate, style: .date)
                                            .foregroundColor(.gray)
                                    } else {
                                        Text("N/A")
                                            .foregroundColor(.gray)
                                    }
                                }

                                
                                HStack {
                                    Text("RSVP Count")
                                    Spacer()
                                    Text("\(viewModel.ticketDetails?.events.rsvpCount ?? 0)")
                                        .foregroundColor(.gray)
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                }
                .padding(.top, 20)
            }
            .foregroundStyle(.primaryText)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Ticket Details")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                await viewModel.getTicketDetails()
            }
        }
    }
}
