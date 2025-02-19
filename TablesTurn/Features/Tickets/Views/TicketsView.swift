import SwiftUI

struct TicketsView: View {
    let radius: CGFloat = 50
    
    @StateObject var viewModel = TicketsViewModel()
    
    init() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(.white),
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
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
                    
                    VStack() {
                        HStack {
                            Text("My Tickets")
                                .font(.system(size: 35))
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 30)
                        
                        VStack {
                            if let userTickets = viewModel.userTickets, !userTickets.isEmpty {
                                ScrollView { // Add ScrollView here
                                    ForEach(userTickets) { eventRsvp in
                                        if let tickets = eventRsvp.tickets, !tickets.isEmpty {
                                            ForEach(tickets) { ticket in
                                                TicketCard(ticket: ticket,
                                                           location: eventRsvp.event.location,
                                                           title: eventRsvp.event.title)
                                            }
                                        } else {
                                            Text("No tickets for this event")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            } else {
                                Text("No tickets available")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 30)
                }
                .padding(.top, 20)
            }
            .foregroundStyle(.primaryText)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Tickets")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await viewModel.getTickets()
                }
            }
        }
    }
}

struct TicketCard: View {
    var ticket: EventTicket
    var location: String
    var title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let url = URL(string: ticket.qrImage) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 100, height: 100)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        case .failure:
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 22))
                    Text(location)
                        .foregroundColor(.gray)
                        .padding(.bottom, 15)
                    
                    HStack {
                        if ticket.redeemed {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Redeemed")
                                .font(.system(size: 14))
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                            Text("Not Redeemed")
                                .font(.system(size: 14))
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ticket.redeemed ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                    )
                }
                .padding(.leading, 8)
            }
            // Explicitly set alignment for the HStack content
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        // And also for the outer VStack container
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    TicketsView()
}
