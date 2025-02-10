import Foundation

struct UserDetails: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let createdAt: Date
    let status: Bool
    let instagramUsername: String?
    let isEmailVerified: Bool
    let twitterUsername: String?
    let profileImage: String?
    let linkedinUsername: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case createdAt = "created_at"
        case status
        case instagramUsername = "instagram_username"
        case isEmailVerified = "is_email_verified"
        case twitterUsername = "twitter_username"
        case profileImage = "profile_image"
        case linkedinUsername = "linkedin_username"
    }
}
