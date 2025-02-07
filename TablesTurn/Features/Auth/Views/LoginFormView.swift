import SwiftUI

struct LoginFormView: View {
    let radius: CGFloat = 50
    
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.accentColor
                    .ignoresSafeArea()
                
                ZStack(alignment: .topLeading) {
                    Color.primaryBackground
                        .ignoresSafeArea()
                        .padding(.bottom, radius)
                        .cornerRadius(radius)
                        .padding(.bottom, -radius)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        (
                            Text("Welcome Back!\n")
                            + Text("Login To Continue")
                                .foregroundStyle(.accent)
                        )
                        .font(.system(size: 43))
                        .fontWeight(.medium)
                        .padding(EdgeInsets(top: 30, leading: 25, bottom: 10, trailing: 25))
                        
                        NavigationLink(destination: SignupFormView()) {
                            Text("CREATE A NEW ACCOUNT")
                                .padding(.leading, 27)
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                        }
                        
                        Form {
                            CustomTextField(
                                placeholder: "Email",
                                text: $viewModel.email,
                                keyboardType: .emailAddress,
                                iconName: "envelope",
                                validation: { input in
                                    if input.isEmpty {
                                        return "Email cannot be empty."
                                    }
                                    if !input.contains("@") {
                                        return "Please enter a valid email."
                                    }
                                    return nil
                                }
                            )
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                            
                            CustomTextField(
                                placeholder: "Password",
                                text: $viewModel.password,
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
                            
                            HStack {
                                Toggle("", isOn: $viewModel.staySignedIn)
                                    .labelsHidden()
                                Text("Stay Signed In")
                                    .foregroundStyle(.gray)
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 5, leading: 20, bottom: 20, trailing: 20))
                            
                            Section {
                                Button(action: {
                                    viewModel.login()
                                }) {
                                    Text("Submit".uppercased())
                                }
                                .buttonStyle(MainButtonStyle())
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 15, leading: 5, bottom: 0, trailing: 5))
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                }
                .padding(.top, 20)
            }
            .foregroundStyle(.primaryText)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationDestination(isPresented: $viewModel.isEmailNotVerified) {
                EmailVerificationView(viewModel: EmailVerificationViewModel(userId: viewModel.id))
            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView()
    }
}
