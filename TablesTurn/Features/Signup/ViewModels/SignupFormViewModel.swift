import Foundation
import Combine

class SignupFormViewModel: ObservableObject {
    // Input fields
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var instagramUsername: String = ""
    @Published var twitterUsername: String = ""
    @Published var linkedinUsername: String = ""
    
    // UI state
    @Published var currentStep: Int = 1
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // MARK: - Business Logic
    
    func validateEmail() {
        guard !email.isEmpty, email.contains("@") else {
            alertMessage = "Please enter a valid email."
            showAlert = true
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.currentStep = 2
        }
    }
    
    func signUp() {
        guard !firstName.isEmpty,
              !lastName.isEmpty,
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
        
        // TODO: Add any further validations or service calls here.
        print("Signup successful!")
    }
}
