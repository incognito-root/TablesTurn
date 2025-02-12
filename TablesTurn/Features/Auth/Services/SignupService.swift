import Foundation

@MainActor
class SignupService {
    func signUp(userDetails: UserSignupDetails) async throws -> UserSignupResponse {
        let parameters: [String: Any] = [
            "userDetails": [
                "first_name": userDetails.firstName,
                "last_name": userDetails.lastName,
                "password": userDetails.password,
                "email": userDetails.email,
                "instagram_username": userDetails.instagramUsername ?? "",
                "twitter_username": userDetails.twitterUsername ?? "",
                "linkedin_username": userDetails.linkedinUsername ?? ""
            ]
        ]
        
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.signup,
            method: .post,
            parameters: parameters
        )
    }
}
