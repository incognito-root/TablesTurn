import SwiftUI

struct UserProfileView: View {
    let radius: CGFloat = 50
    
    @StateObject var viewModel = UserProfileViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.white)]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(.accentColor),
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
                    
                    VStack(spacing: 0) {
                        Form {
                            profileImageSection
                            personalInfoSection
                            socialMediaSection
                            accountInfoSection
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                }
                .padding(.top, 20)
            }
            .foregroundStyle(.primaryText)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if viewModel.isEditing {
                            Task {
                                await viewModel.updateUserDetails()
                            }
                        }
                        viewModel.isEditing.toggle()
                    } label: {
                        Image(systemName: viewModel.isEditing ? "checkmark" : "pencil")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.getUserDetails()
            }
        }
    }
    
    private var profileImageSection: some View {
        Section {
            HStack {
                Spacer()
                AsyncImage(url: URL(string: viewModel.userDetails.profileImage ?? "")) { phase in
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
    }
    
    private var personalInfoSection: some View {
        Section("Personal Information") {
            CustomTextField(
                placeholder: "First Name",
                text: $viewModel.userDetails.firstName,
                isEditable: viewModel.isEditing,
                validation: { input in
                    input.isEmpty ? "First name cannot be empty" : nil
                }
            )
            
            CustomTextField(
                placeholder: "Last Name",
                text: $viewModel.userDetails.lastName,
                isEditable: viewModel.isEditing,
                validation: { input in
                    input.isEmpty ? "Last name cannot be empty" : nil
                }
            )
            
            CustomTextField(
                placeholder: "Email",
                text: $viewModel.userDetails.email,
                keyboardType: .emailAddress,
                isEditable: viewModel.isEditing,
                validation: { input in
                    input.isEmpty ? "Email cannot be empty" : nil
                }
            )
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
    }
    
    private var socialMediaSection: some View {
        Section("Social Media") {
            CustomTextField(
                placeholder: "Instagram",
                text: Binding(
                    get: { viewModel.userDetails.instagramUsername ?? "" },
                    set: { viewModel.userDetails.instagramUsername = $0.isEmpty ? nil : $0 }
                ),
                isEditable: viewModel.isEditing
            )
            
            CustomTextField(
                placeholder: "Twitter",
                text: Binding(
                    get: { viewModel.userDetails.twitterUsername ?? "" },
                    set: { viewModel.userDetails.twitterUsername = $0.isEmpty ? nil : $0 }
                ),
                isEditable: viewModel.isEditing
            )
            
            CustomTextField(
                placeholder: "LinkedIn",
                text: Binding(
                    get: { viewModel.userDetails.linkedinUsername ?? "" },
                    set: { viewModel.userDetails.linkedinUsername = $0.isEmpty ? nil : $0 }
                ),
                isEditable: viewModel.isEditing
            )
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
    }
    
    private var accountInfoSection: some View {
        Section("Account Information") {        
            HStack {
                Text("Joined Date")
                Spacer()
                Text(viewModel.userDetails.createdAt, style: .date)
                    .foregroundColor(.gray)
            }
        }
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
    }
}

#Preview {
    UserProfileView()
}
