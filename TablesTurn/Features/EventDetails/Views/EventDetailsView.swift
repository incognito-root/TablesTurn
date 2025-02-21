import SwiftUI

struct ProfileImageView: View {
    let imageURL: URL?
    
    var body: some View {
        if let url = imageURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 70, height: 70)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
        }
    }
}

struct EventTopImageView: View {
    let imageURL: String?
    let eventTitle: String

    var body: some View {
        if let imageURL = imageURL, !imageURL.isEmpty, let url = URL(string: imageURL) {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .frame(height: 350)
                } else if phase.error != nil {
                    Color.red
                } else {
                    Color.gray
                }
            }
        } else {
            Text(eventTitle)
                .font(.title)
                .frame(maxWidth: .infinity, minHeight: 350)
                .background(Color.gray.opacity(0.3))
        }
    }
}


struct EventBioView: View {
    let title: String?
    let hostName: String?
    let image: String?
    
    var body: some View {
        HStack {
               VStack(alignment: .leading) {
                   Text(title ?? "Title")
                       .font(.system(size: 35))
                       .fontWeight(.medium)
                       .frame(maxWidth: 250, alignment: .leading)
                       .lineLimit(2)
                       .truncationMode(.tail)
       
                   Text("An event by " + (hostName ?? "hostname"))
                       .fontWeight(.medium)
                       .frame(maxWidth: 250, alignment: .leading)
                       .foregroundStyle(Color.gray)
                       .lineLimit(2)
                       .truncationMode(.tail)
               }
       
               Spacer()
       
               VStack(alignment: .trailing) {
                   ProfileImageView(imageURL: URL(string: image ?? ""))
               }
           }
    }
}

struct EventAttendanceView: View {
    let rsvpCount: String
    let imageValues: [String]
    
    var body: some View {
        HStack {
            Text(rsvpCount + " people attending")
                .font(.headline)
                .foregroundStyle(Color.white)
            
            Spacer()
            
            AvatarStack(imageUrls: imageValues)
        }
    }
}

struct RSVPModalView: View {
    var onDismiss: (() -> Void)?
    @StateObject private var viewModel: EventDetailsViewModel
    
    init(viewModel: EventDetailsViewModel, onDismiss: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss?()
                }
            
            VStack(spacing: 20) {
                Text("Confirm RSVP")
                    .font(.headline)
                    .padding(.bottom, 20)
                
                HStack {
                    Text("Attendees")
                        .padding(.leading, 5)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                    
                    CustomDropdownView(
                        title: "Attendees",
                        options: [1, 2, 3, 4],
                        selection: $viewModel.attendees,
                        displayText: { "\($0)" }
                    )
                }
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text("Status")
                        .padding(.leading, 5)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                    
                    CustomDropdownView(
                        title: "Rsvp Status",
                        options: viewModel.rsvpStatuses ?? [],
                        selection: $viewModel.selectedRsvpStatus,
                        displayText: { $0?.title ?? "" }
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
                
                Button(action: {
                    viewModel.showRsvpModal = true
                    Task {
                        await viewModel.rsvpToEvent()
                    }
                }) {if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Confirm".uppercased())
                }
                }
                .buttonStyle(MainButtonStyle(
                    padding: 9,
                    fontSize: 20,
                    foregroundColor: .white
                ))
                .disabled(viewModel.isLoading)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
            }
            .padding()
            .background(Color.primaryBackground)
            .cornerRadius(30)
            .padding(.horizontal, 40)
            .transition(.scale)
            .frame(maxWidth: .infinity)
        }
    }
}

struct EventDetailsView: View {
    let radius: CGFloat = 50
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: EventDetailsViewModel
    
    init(id: String) {
        self.viewModel = EventDetailsViewModel(eventId: id)
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
    }
    
    var formattedEventDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: viewModel.eventDetails?.dateTime ?? Date())
    }
    
    var formattedEventRsvp: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: viewModel.eventDetails?.rsvpDeadline ?? Date())
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
                    
                    VStack {
                        ZStack {
                            EventTopImageView(
                                imageURL: viewModel.eventDetails?.image,
                                eventTitle: viewModel.eventDetails?.title ?? ""
                            )
                            
                            Color.black.opacity(0.60)
                            
                            VStack(alignment: .trailing) {
                                HStack {
                                    Button(action: {
                                        // Your action here
                                    }) {
                                        Image(systemName: "bookmark")
                                            .font(.system(size: 15))
                                    }
                                    .buttonStyle(CircularButtonStyle(
                                        size: 35,
                                        backgroundColor: .clear,
                                        foregroundColor: .white,
                                        borderColor: .white,
                                        borderWidth: 1
                                    ))
                                    
                                    Button(action: {
                                        // Your action here
                                    }) {
                                        Image(systemName: "square.and.arrow.up")
                                            .font(.system(size: 15))
                                    }
                                    .buttonStyle(CircularButtonStyle(
                                        size: 35,
                                        backgroundColor: .clear,
                                        foregroundColor: .white,
                                        borderColor: .white,
                                        borderWidth: 1
                                    ))
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                            .padding(20)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 10) {
                                    ZStack {
                                        HStack {
                                            Image(systemName: "calendar")
                                                .foregroundStyle(.white)
                                            Text(formattedEventDate)
                                                .font(.system(size: 14))
                                                .foregroundStyle(.white)
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 10)
                                    .background(Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                    
                                    ZStack {
                                        HStack {
                                            Image(systemName: "mappin.circle")
                                                .foregroundStyle(.white)
                                            Text(viewModel.eventDetails?.location ?? "Location")
                                                .font(.system(size: 14))
                                                .foregroundStyle(.white)
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 10)
                                    .background(Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                            .padding(20)
                            .padding(.bottom, 40)
                            
                        }
                        .frame(height: 350)
                        .clipShape(RoundedRectangle(cornerRadius: radius))
                        
                        VStack() {
                            VStack(alignment: .leading, spacing: 30) {
                                EventBioView(
                                    title: viewModel.eventDetails?.title,
                                    hostName: viewModel.eventDetails?.userDetails.firstName,
                                    image: viewModel.eventDetails?.userDetails.profileImage
                                )
                            
                                Text("Description")
                            
                                HStack {
                                    EventAttendanceView(
                                        rsvpCount: String(viewModel.eventDetails?.rsvpCount ?? 0),
                                        imageValues: (viewModel.recentRsvpImages ?? [])
                                    )
                                }
                                
                                if viewModel.eventDetails?.rsvpDeadline != nil {
                                    Text("RSVP Before " + formattedEventRsvp)
                                }
                            
                                Button(action: {
                                    viewModel.showRsvpModal = true
                                }) {
                                    Text("RSVP".uppercased())
                                }
                                .buttonStyle(MainButtonStyle(
                                    foregroundColor: .white
                                ))
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                            }
                            .padding(20)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .background(Color.primaryBackground)
                        .padding(.top, -radius)
                    }
                }
                .padding(.top, 20)
                
                if viewModel.showRsvpModal {
                    RSVPModalView(viewModel: self.viewModel) {
                        withAnimation {
                            viewModel.showRsvpModal = false
                        }
                    }
                }
                
                if viewModel.showSuccessModal {
                    SuccessModalView(textToShow: "RSVP'd To Event Successfully. An email containing QR code is sent on your email") {
                        viewModel.showSuccessModal = false
                        dismiss()
                    }
                }
            }
            .foregroundStyle(.primaryText)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await viewModel.getEventDetails()
                    await viewModel.getRecentRsvpsImages()
                }
                
                Task {
                    await viewModel.getRsvpStatuses()
                }
            }
        }
    }
}

#Preview {
    EventDetailsView(id: "1")
}
