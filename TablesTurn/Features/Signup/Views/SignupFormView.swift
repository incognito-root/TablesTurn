import SwiftUI

struct SignupFormView: View {
    let radius: CGFloat = 50
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var instagramUsername: String = ""
    @State private var twitterUsername: String = ""
    @State private var linkedinUsername: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var currentStep = 1
    
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
                        if currentStep == 1 {
                            (
                                Text("Enter Your Email\n")
                                + Text("To Get Started")
                                    .foregroundStyle(.accent)
                            )
                            .font(.system(size: 43))
                            .fontWeight(.medium)
                            .padding(EdgeInsets(top: 20, leading: 25, bottom: 0, trailing: 25))
                            
                            Form {
                                Section {
                                    CustomTextField(
                                        placeholder: "Email",
                                        text: $email,
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
                                    Button(action: validateEmail) {
                                        Text("Next".uppercased())
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
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
                            .padding(EdgeInsets(top: 20, leading: 32, bottom: 0, trailing: 25))
                            
                            Form {
                                Section {
                                    CustomTextField(
                                        placeholder: "First Name",
                                        text: $name,
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
                                        text: $name,
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
                                        text: $password,
                                        isSecure: true,
                                        keyboardType: .default,
                                        iconName: "lock",
                                        validation: { input in
                                            if input.isEmpty {
                                                return "Password cannot be empty."
                                            }
                                            if input.count < 8 {
                                                return "Password must be at least 8 characters."
                                            }
                                            return nil
                                        }
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                    
                                    CustomTextField(
                                        placeholder: "Confirm Password",
                                        text: $confirmPassword,
                                        isSecure: true,
                                        keyboardType: .default,
                                        iconName: "lock",
                                        validation: { input in
                                            if input.isEmpty {
                                                return "Password cannot be empty."
                                            }
                                            if input != self.password {
                                                return "Passwords do not match"
                                            }
                                            return nil
                                        }
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                    
                                    CustomTextField(
                                        placeholder: "Instagram Username",
                                        text: $instagramUsername,
                                        keyboardType: .default,
                                        iconName: "person"
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                    
                                    CustomTextField(
                                        placeholder: "Twitter Username",
                                        text: $twitterUsername,
                                        keyboardType: .default,
                                        iconName: "person"
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                    
                                    CustomTextField(
                                        placeholder: "Linkedin Username",
                                        text: $linkedinUsername,
                                        keyboardType: .default,
                                        iconName: "person"
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                }
                                
                                Section {
                                    Button(action: signUp) {
                                        Text("Sign Up".uppercased())
                                    }
                                    .buttonStyle(PrimaryButtonStyle())
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarHidden(true)
    }
    
    func validateEmail() {
        guard !email.isEmpty, email.contains("@") else {
            alertMessage = "Please enter a valid email."
            showAlert = true
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // For demonstration, assume all emails pass.
            // If the email is already in use, you can set an error message and showAlert.
            // e.g.,
            // if emailAlreadyInUse(email) {
            //     alertMessage = "This email is already in use."
            //     showAlert = true
            // } else {
            //     currentStep = 2
            // }
            
            currentStep = 2
        }
    }
    
    func signUp() {
        guard !name.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            alertMessage = "All fields are required."
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        print("Signup successful!")
    }
}

#Preview {
    SignupFormView()
}
