import Foundation

@MainActor
class EmailVerificationViewModel: ObservableObject {
    @Published var otp: [String] = Array(repeating: "", count: 6)
    @Published var focusedField: Int?
    @Published var userId: String?
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let service = EmailVerificationService()
    
    init(userId: String? = nil) {
        self.userId = userId
    }
    
    func verifyOTP() {
        Task {
            let enteredOTP = otp.joined()
            
            guard enteredOTP.count == 6 else {
                showAlert(message: "Please enter 6 digits")
                return
            }
            
            guard let userId = userId else {
                showAlert(message: "Missing user ID")
                return
            }
            
            let verificationDetails = EmailVerificationDetails(
                userId: userId,
                otp: enteredOTP
            )
            
            do {
                let response = try await service.verifyOtp(details: verificationDetails)
                await handleSuccess(response: response)
            } catch let error as APIError {
                handleAPIError(error: error)
            } catch {
                showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func handleSuccess(response: EmailVerificationResponse) async {
        let userToSave = User(id: response.id)
        UserManager.shared.currentUser = userToSave
    }
    
    private func handleAPIError(error: APIError) {
        switch error {
        case .serverError(let message):
            showAlert(message: message)
        case .decodingError:
            showAlert(message: "Failed to process server response")
        case .invalidResponse:
            showAlert(message: "Invalid server response")
        case .emailNotVerified:
            showAlert(message: "Email verification required")
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    // UI handling remains unchanged
    func handleOTPChange(index: Int, newValue: String) {
        if newValue.count > 1 {
            otp[index] = String(newValue.prefix(1))
        }
        if newValue.count == 1 && index < 5 {
            focusedField = index + 1
        }
    }
}
