import Foundation
import Combine

class SignupViewModel: ObservableObject {
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
    
    private let signupService = SignupService()
    
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
        
        let userDetails = UserRegistrationDetails(
            firstName: firstName,
            lastName: lastName,
            password: password,
            email: email,
            instagramUsername: instagramUsername.isEmpty ? nil : instagramUsername,
            twitterUsername: twitterUsername.isEmpty ? nil : twitterUsername,
            linkedinUsername: linkedinUsername.isEmpty ? nil : linkedinUsername
        )
        
        // Call the signup service.
        signupService.signUp(userDetails: userDetails) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    print("Signup successful! User: \(user)")
                    
                case .failure(let error):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Prevent nested state updates
                        self.alertMessage = error.localizedDescription
                        self.showAlert = true
                    }
                }
            }
        }
    }
}
