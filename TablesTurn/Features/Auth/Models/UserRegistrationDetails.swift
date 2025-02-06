import Foundation

struct UserRegistrationDetails: Codable {
    let firstName: String
    let lastName: String
    let password: String
    let email: String
    let instagramUsername: String?
    let twitterUsername: String?
    let linkedinUsername: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case password
        case email
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case linkedinUsername = "linkedin_username"
    }
}
