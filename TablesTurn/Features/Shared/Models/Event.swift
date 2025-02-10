import Foundation

struct Event: Codable, Identifiable {
    let id: String
    let title: String
    let timezone: String
    let rsvpDeadline: Date?
    let location: String
    let image: String?
    let description: String
    let status: Bool
    let rsvpCount: Int
    let dateTime: Date
    let createdAt: Date?
    let fkUserId: String

    enum CodingKeys: String, CodingKey {
        case id, title, timezone, location, image, description, status
        case rsvpDeadline = "rsvp_deadline"
        case rsvpCount = "rsvp_count"
        case dateTime = "date_time"
        case createdAt = "created_at"
        case fkUserId = "fk_user_id"
    }
}
