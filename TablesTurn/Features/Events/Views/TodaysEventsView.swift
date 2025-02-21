import SwiftUI

struct TodaysEventsView: View {
    let radius: CGFloat = 50
    
    @StateObject private var viewModel = TodaysEventsViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
    }
    
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
                    
                    VStack(alignment: .leading, spacing: 0) {
                        VStack {
                            Text(formattedDate.day + " " + formattedDate.date + "\nEvents")
                                .font(.system(size: 35))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // Centers the VStack
                        
                        ScrollView {
                            VStack(spacing: 20) {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                } else if viewModel.events.isEmpty {
                                    Text("No events found")
                                        .frame(height: 230)
                                        .frame(maxWidth: .infinity)
                                        .font(.system(size: 30))
                                        .foregroundStyle(Color.gray)
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
                        .padding(EdgeInsets(top: 20, leading: 25, bottom: 0, trailing: 25))
                    }
                    .padding(.top, 10)
                }
                .padding(.top, 20)
            }
            .foregroundStyle(.primaryText)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Today's Events")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                Task {
                    await viewModel.getTodaysEvents()
                }
            }
        }
    }
}

#Preview {
    UserEventsView()
}
