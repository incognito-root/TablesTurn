import Foundation

@MainActor
class LoginService {
    func login(userDetails: UserLoginDetails) async throws -> UserLoginResponse {
        let parameters: [String: Any] = [
            "email": userDetails.email,
            "password": userDetails.password,
            "staySignedIn": userDetails.staySignedIn
        ]
        
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.login,
            method: .post,
            parameters: parameters
        )
    }
}
