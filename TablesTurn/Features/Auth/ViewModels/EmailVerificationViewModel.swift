import Foundation

class EmailVerificationViewModel: ObservableObject {
    @Published var otp: [String] = Array(repeating: "", count: 6)
    @Published var focusedField: Int?
    @Published var userId: String?
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let emailVerificationService = EmailVerificationService()
    
    init(userId: String? = nil) {
        self.userId = userId
    }
    
    func verifyOTP() {
        let enteredOTP = otp.joined()
        
        if enteredOTP.count < 6 {
            alertMessage = "Please enter 6 digits"
            showAlert = true
            return
        }
        
        let verificationDetails = EmailVerificationDetails(
            userId: self.userId ?? "",
            otp: enteredOTP
        )
        
        emailVerificationService.verifyOtp(details: verificationDetails) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    let userToSave = User(id: user.id)
                    UserManager.shared.currentUser = userToSave
                    
                case .failure(let error):
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
    
    func handleOTPChange(index: Int, newValue: String) {
        if newValue.count > 1 {
            otp[index] = String(newValue.prefix(1))
        }
        if newValue.count == 1 && index < 5 {
            focusedField = index + 1
        }
    }
}
