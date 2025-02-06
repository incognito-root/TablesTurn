import Foundation

struct UserLoginResponse: Codable {
    let id: String
    let email: String
    let isEmailVerified: Bool
}
