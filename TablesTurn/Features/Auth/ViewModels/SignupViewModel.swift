import Foundation

@MainActor
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
    @Published var signedUp: Bool = false
    @Published var isLoading = false
    
    private let service = SignupService()
    private let loginViewModel = LoginViewModel()

    func validateEmail() {
        guard !email.isEmpty, email.contains("@") else {
            showAlert(message: "Please enter a valid email.")
            isLoading = false
            return
        }
        
        Task {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            currentStep = 2
        }
    }
    
    func signUp() {
        isLoading = true
        
        Task {
            guard validateFields() else {
                isLoading = false
                return
            }
            
            let userDetails = UserSignupDetails(
                firstName: firstName,
                lastName: lastName,
                password: password,
                email: email,
                instagramUsername: instagramUsername.nilIfEmpty,
                twitterUsername: twitterUsername.nilIfEmpty,
                linkedinUsername: linkedinUsername.nilIfEmpty
            )
            
            do {
                _ = try await service.signUp(userDetails: userDetails)
                signedUp = true
                
                isLoading = false
            } catch let error as APIError {
                isLoading = false
                handleAPIError(error: error)
            } catch {
                isLoading = false
                showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func validateFields() -> Bool {
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmPassword.isEmpty else {
            showAlert(message: "All fields are required.")
            return false
        }
        
        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match.")
            return false
        }
        
        return true
    }
    
    private func handleAPIError(error: APIError) {
        switch error {
        case .serverError(let message):
            showAlert(message: message)
        case .decodingError:
            showAlert(message: "Failed to process server response.")
        case .invalidResponse:
            showAlert(message: "Invalid response from server.")
        case .emailNotVerified:
            showAlert(message: "Email verification required")
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

extension String {
    var nilIfEmpty: String? {
        self.isEmpty ? nil : self
    }
}
