import Foundation

struct EmailVerificationDetails: Codable {
    let userId: String
    let otp: String
}
