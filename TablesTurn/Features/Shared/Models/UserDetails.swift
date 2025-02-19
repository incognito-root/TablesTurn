import Foundation

struct UserDetails: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var createdAt: Date
    var status: Bool
    var instagramUsername: String?
    var isEmailVerified: Bool
    var twitterUsername: String?
    var profileImage: String?
    var linkedinUsername: String?

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
