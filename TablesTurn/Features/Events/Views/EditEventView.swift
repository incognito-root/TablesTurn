import SwiftUI

struct EditEventView: View {
    let eventId: String
    let radius: CGFloat = 50
    @StateObject var viewModel = EditEventViewModel()
    
    init(eventId: String) {
        self.eventId = eventId
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
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            Form {
                                Section {
                                    HStack {
                                        Spacer()
                                        AsyncImage(url: URL(string: viewModel.image)) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 100, height: 100)
                                                    .clipShape(Circle())
                                            } else {
                                                Image(systemName: "photo.circle.fill")
                                                    .resizable()
                                                    .frame(width: 100, height: 100)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .listRowBackground(Color.clear)
                                }
                                .listRowBackground(Color.clear)
                                
                                Section() {
                                    CustomTextField(
                                        placeholder: "Title",
                                        text: $viewModel.title,
                                        textColor: .white,
                                        isEditable: viewModel.editing,
                                        validation: { input in
                                            input.isEmpty ? "Title is required" : nil
                                        }
                                    )
                                    
                                    CustomTextField(
                                        placeholder: "Location",
                                        text: $viewModel.location,
                                        textColor: .white,
                                        isEditable: viewModel.editing,
                                        validation: { input in
                                            input.isEmpty ? "Location is required" : nil
                                        }
                                    )
                                    
                                    CustomTextField(
                                        placeholder: "Description",
                                        text: $viewModel.description,
                                        textColor: .white,
                                        isEditable: viewModel.editing,
                                        validation: { input in
                                            input.isEmpty ? "Description is required" : nil
                                        }
                                    )
                                }
                            header: {
                                Text("Event Information")
                                    .foregroundColor(.white)
                            }
                            .listRowBackground(Color.clear)
                                
                                Section() {
                                    HStack {
                                        Text("Date")
                                            .foregroundStyle(Color.white)
                                        Spacer()
                                        Text(viewModel.date, style: .date)
                                            .foregroundStyle(Color.white)
                                        
                                    }
                                    
                                    HStack {
                                        Text("Time")
                                            .foregroundStyle(Color.white)
                                        Spacer()
                                        Text(viewModel.time, style: .time)
                                            .foregroundStyle(Color.white)
                                        
                                    }
                                }
                            header: {
                                Text("Event Information")
                                    .foregroundColor(.white)
                            }
                            .listRowBackground(Color.clear)
                                
                                Section() {
                                    HStack {
                                        Text("RSVP Deadline")
                                            .foregroundStyle(Color.white)
                                        Spacer()
                                        Text(viewModel.rsvpDeadlineDate, style: .date)
                                            .foregroundStyle(Color.white)
                                    }
                                }
                            header: {
                                Text("Event Information")
                                    .foregroundColor(.white)
                            }
                            .listRowBackground(Color.clear)
                            }
                            .scrollContentBackground(.hidden)
                        }
                    }
                }
                .padding(.top, 20)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if viewModel.editing {
                            Task {
                                await viewModel.editEvent()
                            }
                        }
                        viewModel.editing.toggle()
                    } label: {
                        Image(systemName: viewModel.editing ? "checkmark" : "pencil")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            viewModel.eventId = eventId
            Task {
                await viewModel.getEventDetails()
            }
        }
    }
}
