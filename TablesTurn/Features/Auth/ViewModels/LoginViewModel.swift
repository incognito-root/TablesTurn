import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var id: String = ""
    @Published var staySignedIn: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isEmailNotVerified: Bool = false
    
    private let service = LoginService()
    
    func login() {
        Task {
            guard validateFields() else { return }
            
            let userDetails = UserLoginDetails(
                email: email,
                password: password,
                staySignedIn: staySignedIn
            )
            
            do {
                let user = try await service.login(userDetails: userDetails)
                await handleSuccess(user: user)
            } catch let error as APIError {
                handleAPIError(error: error)
            } catch {
                showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func validateFields() -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(message: "All fields are required.")
            return false
        }
        return true
    }
    
    private func handleSuccess(user: UserLoginResponse) async {
        let userToSave = User(id: user.id)
        UserManager.shared.currentUser = userToSave
        UserManager.shared.saveUser(userToSave)
    }
    
    private func handleAPIError(error: APIError) {
        switch error {
        case .serverError(let message):
            showAlert(message: message)
        case .decodingError:
            showAlert(message: "Failed to process server response")
        case .invalidResponse:
            showAlert(message: "Invalid server response")
        case .emailNotVerified(let userId):
            id = userId ?? ""
            isEmailNotVerified = true
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
