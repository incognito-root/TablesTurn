import SwiftUI

struct AccountSettingsView: View {
    let radius: CGFloat = 50
    
    @StateObject var viewModel = AccountSettingsViewModel()
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var isPasswordValid = false
    
    @Environment(\.dismiss) var dismiss
    
    init() {
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
                    
                    VStack(alignment: .leading, spacing: 0) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {                            
                            Form {
                                Section("Change Password") {
                                    CustomTextField(
                                        placeholder: "Current Password",
                                        text: $currentPassword,
                                        isSecure: true,
                                        keyboardType: .default,
                                        iconName: "lock",
                                        validation: { input in
                                            if input.isEmpty {
                                                return "Password cannot be empty."
                                            }
                                            if input.count < 7 {
                                                return "Password must be at least 8 characters."
                                            }
                                            return nil
                                        }
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                    
                                    CustomTextField(
                                        placeholder: "New Password",
                                        text: $newPassword,
                                        isSecure: true,
                                        keyboardType: .default,
                                        iconName: "lock",
                                        validation: { input in
                                            if input.isEmpty {
                                                return "Password cannot be empty."
                                            }
                                            return nil
                                        }
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                    
                                    Button(action: {
                                        Task {
                                            await viewModel.changePassword(
                                                currentPassword: currentPassword,
                                                newPassword: newPassword
                                            )
                                        }
                                    }) {
                                        if viewModel.isLoading {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        } else {
                                            Text("Save".uppercased())
                                        }
                                    }
                                    .buttonStyle(MainButtonStyle())
                                    .listRowBackground(Color.clear)
                                    .disabled(viewModel.isLoading)
                                    .listRowInsets(EdgeInsets(top: 20, leading: 5, bottom: 50, trailing: 5))
                                }
                                
                                Section {
                                    Button("Delete Account Permanently") {
                                        viewModel.showDeleteConfirmationModal = true
                                    }
                                    .foregroundColor(.red)
                                } header: {
                                    Text("Delete Account")
                                        .foregroundColor(.primaryText)
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
                .padding(.top, 20)
                
                if viewModel.showSuccessModal {
                    SuccessModalView(textToShow: "Password Changed Successfully!") {
                        viewModel.showSuccessModal = false
                        dismiss()
                    }
                }
                
                if viewModel.showDeleteConfirmationModal {
                    ConfirmationModalView(
                        message: "Are you sure you want to delete your account?\n\nPlease note that this will also remove all the events you're hosting, and this action cannot be undone.",
                        isDeleting: viewModel.isDeleting,
                        onCancel: {
                            viewModel.showDeleteConfirmationModal = false
                        },
                        onConfirm: {
                            Task {
                                await viewModel.deleteAccount()
                            }
                        }
                    )
                }
            }
            .foregroundStyle(.primaryText)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Account Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: viewModel.deleteSuccess) {
            if viewModel.deleteSuccess {
                dismiss()
            }
        }
        .onAppear {
            // Reset form on appearance
            currentPassword = ""
            newPassword = ""
            validateForm()
        }
    }
    
    private func validateForm() {
        isPasswordValid = !currentPassword.isEmpty && newPassword.count >= 8
    }
}

struct ConfirmationModalView: View {
    let message: String
    var isDeleting: Bool
    var onCancel: () -> Void
    var onConfirm: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(message)
                    .font(.headline)
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 10)
                
                if isDeleting {
                    ProgressView()
                } else {
                    HStack(spacing: 20) {
                        Button("Cancel") {
                            onCancel()
                        }
                        .buttonStyle(MainButtonStyle(backgroundColor: .gray))
                        
                        Button("Delete") {
                            onConfirm()
                        }
                        .buttonStyle(MainButtonStyle(backgroundColor: .red))
                    }
                }
            }
            .padding()
            .background(Color.primaryBackground)
            .cornerRadius(20)
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    AccountSettingsView()
}
