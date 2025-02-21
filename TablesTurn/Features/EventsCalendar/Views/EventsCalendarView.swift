import SwiftUI

struct EventsCalendarView: View {
    let radius: CGFloat = 50
    
    @StateObject private var viewModel = AddEventsCalendarViewModel()
    
    @State private var date = Date()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white,
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
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Button {
                                withAnimation {
                                    viewModel.selectedMonthIndex = (viewModel.selectedMonthIndex - 1 + 12) % 12
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .padding(8)
                            }
                            .onChange(of: viewModel.selectedMonthIndex) { _, _ in
                                viewModel.getEventsByMonth()
                            }
                            
                            ScrollViewReader { proxy in
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(viewModel.months.indices, id: \.self) { index in
                                            Text(viewModel.months[index])
                                                .font(.system(size: viewModel.selectedMonthIndex == index ? 40 : 30,
                                                              weight: .bold))
                                                .foregroundColor(viewModel.selectedMonthIndex == index ? .white : .gray)
                                                .frame(width: 90)
                                                .id(index)
                                        }
                                    }
                                    .scrollTargetLayout()
                                }
                                .scrollTargetBehavior(.viewAligned)
                                .frame(width: 280, height: 50)
                                .onChange(of: viewModel.selectedMonthIndex) { _, newValue in
                                    withAnimation {
                                        proxy.scrollTo(newValue, anchor: .center)
                                    }
                                }
                                .onAppear {
                                    proxy.scrollTo(viewModel.selectedMonthIndex, anchor: .center)
                                }
                            }
                            
                            Button {
                                withAnimation {
                                    viewModel.selectedMonthIndex = (viewModel.selectedMonthIndex + 1) % 12
                                }
                            } label: {
                                Image(systemName: "chevron.right")
                                    .padding(8)
                            }
                            .onChange(of: viewModel.selectedMonthIndex) { _, _ in
                                viewModel.getEventsByMonth()
                            }
                        }
                        .padding()
                        .backgroundStyle(Color.clear)
                        
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
                                        EventCard(event: event)
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
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                viewModel.getEventsByMonth()
            }
        }
    }
}

#Preview {
    EventsCalendarView()
}
