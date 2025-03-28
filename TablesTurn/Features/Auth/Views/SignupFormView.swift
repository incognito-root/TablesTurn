import SwiftUI

struct SignupFormView: View {
    let radius: CGFloat = 50
    
    @StateObject private var viewModel = SignupViewModel()
    @StateObject private var loginViewModel = LoginViewModel()
    
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
                        if viewModel.currentStep == 1 {
                            Text("Enter Your Email\nTo Get Started")
                                .font(.system(size: 43))
                                .fontWeight(.medium)
                                .padding(EdgeInsets(top: 20, leading: 25, bottom: 0, trailing: 25))
                            NavigationLink(destination: LoginFormView()) {
                                Text("CLICK HERE TO LOGIN")
                                    .padding(.top, 15)
                                    .padding(.leading, 25)
                                    .font(.system(size: 15))
                                    .foregroundStyle(.gray)
                                    .fontWeight(.bold)
                            }
                            
                            Form {
                                Section {
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
                                }
                                
                                Section {
                                    Button(action: {
                                        viewModel.validateEmail()
                                    }) {
                                        Text("Next".uppercased())
                                    }
                                    .buttonStyle(MainButtonStyle(
                                        foregroundColor: .white
                                    ))
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                        } else {
                            (
                                Text("Almost There!")
                            )
                            .font(.system(size: 43))
                            .fontWeight(.medium)
                            .padding(EdgeInsets(top: 20, leading: 32, bottom: 5, trailing: 25))
                            
                            Form {
                                Section {
                                    CustomTextField(
                                        placeholder: "First Name",
                                        text: $viewModel.firstName,
                                        keyboardType: .default,
                                        iconName: "person",
                                        validation: { input in
                                            if input.isEmpty {
                                                return "First name cannot be empty."
                                            }
                                            return nil
                                        }
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                    
                                    CustomTextField(
                                        placeholder: "Last Name",
                                        text: $viewModel.lastName,
                                        keyboardType: .default,
                                        iconName: "person",
                                        validation: { input in
                                            if input.isEmpty {
                                                return "Last name cannot be empty."
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
                                            if input.count < 7 {
                                                return "Password must be at least 8 characters."
                                            }
                                            return nil
                                        }
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                    
                                    CustomTextField(
                                        placeholder: "Confirm Password",
                                        text: $viewModel.confirmPassword,
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
                                    
                                    CustomTextField(
                                        placeholder: "Instagram Username (Optional)",
                                        text: $viewModel.instagramUsername,
                                        keyboardType: .default,
                                        iconName: "person"
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                    
                                    CustomTextField(
                                        placeholder: "Twitter Username (Optional)",
                                        text: $viewModel.twitterUsername,
                                        keyboardType: .default,
                                        iconName: "person"
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                    
                                    CustomTextField(
                                        placeholder: "Linkedin Username (Optional)",
                                        text: $viewModel.linkedinUsername,
                                        keyboardType: .default,
                                        iconName: "person"
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))

                                    Button(action: {
                                        viewModel.signUp()
                                    }) {
                                        if viewModel.isLoading {
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        } else {
                                            Text("Sign Up".uppercased())
                                        }
                                    }
                                    .buttonStyle(MainButtonStyle())
                                    .listRowBackground(Color.clear)
                                    .disabled(viewModel.isLoading)
                                    .listRowInsets(EdgeInsets(top: 20, leading: 5, bottom: 50, trailing: 5))
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                }
                .padding(.top, 20)
            }
            .foregroundStyle(.primaryText)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $viewModel.signedUp) {
            LoginFormView()
        }
    }
}

#Preview {
    SignupFormView()
}
