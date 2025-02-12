import Foundation

@MainActor
class EmailVerificationService {
    func verifyOtp(details: EmailVerificationDetails) async throws -> EmailVerificationResponse {
        let parameters: [String: Any] = [
            "userId": details.userId,
            "otp": details.otp
        ]
        
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.emailVerification,
            method: .post,
            parameters: parameters
        )
    }
}
