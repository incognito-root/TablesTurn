import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var id: String = ""
    @Published var staySignedIn: Bool = false
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var isEmailNotVerified: Bool = false
    
    private let loginService = LoginService()
    
    func login() {
        guard  !email.isEmpty,
               !password.isEmpty
        else {
            alertMessage = "All fields are required."
            showAlert = true
            return
        }
        
        let userDetails = UserLoginDetails(
            email: email,
            password: password,
            staySignedIn: staySignedIn
        )
        
        loginService.login(userDetails: userDetails) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    let userToSave = User(id: user.id)
                    UserManager.shared.currentUser = userToSave
                    UserManager.shared.saveUser(userToSave)
                    
                case .failure(let error):
                    // Handle specific error types
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .serverError(let message):
                            self.alertMessage = message
                        case .decodingError:
                            self.alertMessage = "Failed to process server response"
                        case .invalidResponse:
                            self.alertMessage = "Invalid server response"
                        case .emailNotVerified(let userId):
                            self.id = userId ?? ""
                            self.isEmailNotVerified = true
                        }
                    } else {
                        self.alertMessage = error.localizedDescription
                    }
                    
                    if self.isEmailNotVerified == false {
                        self.showAlert = true
                    }
                }
            }
        }
    }
}
