import Foundation

struct UserLoginDetails: Codable {
    let email: String
    let password: String
    let staySignedIn: Bool
}
