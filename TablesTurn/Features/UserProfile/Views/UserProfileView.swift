import SwiftUI

struct UserProfileView: View {
    let radius: CGFloat = 50
    
    @StateObject var viewModel = UserProfileViewModel()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(Color.clear) // Set your desired background color
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
                                        
                                        if viewModel.isEditing == false {
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
                                        } else {
                                            VStack(alignment: .leading) {
                                                ImagePickerView(viewModel: viewModel.imagePickerViewModel)
                                            }
                                            .frame(maxWidth: .infinity)
                                            .listRowBackground(Color.clear)
                                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                        }
                                        
                                        Spacer()
                                    }
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                }
                                
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
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                        }
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
            viewModel.resetImage()
            
            Task {
                await viewModel.getUserDetails()
            }
        }
    }
}

#Preview {
    UserProfileView()
}
