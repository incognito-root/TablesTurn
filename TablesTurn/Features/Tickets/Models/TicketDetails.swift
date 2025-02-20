import Foundation

struct TicketDetails: Codable, Identifiable {
    let ticketId: String
    let redeemed: Bool
    let redeemedAt: Date
    let qrImage: String
    let users: UserDetailsPartial
    let events: EventDetailsPartial
    
    var id: String {
        return ticketId
    }
    
    enum CodingKeys: String, CodingKey {
        case redeemed, users, events
        case ticketId = "id"
        case redeemedAt = "redeemed_at"
        case qrImage = "qr_image"
    }
}

struct UserDetailsPartial: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var instagramUsername: String?
    var twitterUsername: String?
    var profileImage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case profileImage = "profile_image"
    }
}

struct EventDetailsPartial: Codable, Identifiable {
    let id: String
    let title: String
    let rsvpDeadline: Date?
    let location: String
    let status: Bool
    let rsvpCount: Int
    let dateTime: Date
   
    enum CodingKeys: String, CodingKey {
        case id, title, location, status
        case rsvpDeadline = "rsvp_deadline"
        case rsvpCount = "rsvp_count"
        case dateTime = "date_time"
    }
}
