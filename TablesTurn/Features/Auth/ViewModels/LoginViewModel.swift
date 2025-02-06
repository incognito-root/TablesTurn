import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
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
            staySignedIn: false
        )
        
        loginService.login(userDetails: userDetails) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    print("Login successful! User: \(user)")
                    
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
                        case .emailNotVerified:
                            print("email not verified")
                        }
                    } else {
                        self.alertMessage = error.localizedDescription
                    }
                    self.showAlert = true
                }
            }
        }
    }
    
    func loginAfterSignup(email: String, password: String, completion: @escaping (Result<UserLoginResponse, Error>) -> Void) {
        let userDetails = UserLoginDetails(
            email: email,
            password: password,
            staySignedIn: false
        )
        
        print("in login after sign up")
        
        loginService.login(userDetails: userDetails) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    print("Login successful! User: \(user)")
                    completion(.success(user))
                    
                case .failure(let error):
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .emailNotVerified:
                            self.alertMessage = "Please verify your email before logging in."
                        case .serverError(let message):
                            self.alertMessage = message
                        case .decodingError:
                            self.alertMessage = "Failed to process server response"
                        case .invalidResponse:
                            self.alertMessage = "Invalid server response"
                        }
                    } else {
                        self.alertMessage = error.localizedDescription
                    }
                    self.showAlert = true
                }
            }
        }
    }
}
