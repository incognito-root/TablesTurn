import Foundation

struct Event: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let rsvpDeadline: Date?
    let location: String
    let image: String?
    let description: String
    let status: Bool
    let rsvpCount: Int
    let dateTime: Date
    let createdAt: Date?
    let fkUserId: String
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, location, image, description, status
        case rsvpDeadline = "rsvp_deadline"
        case rsvpCount = "rsvp_count"
        case dateTime = "date_time"
        case createdAt = "created_at"
        case fkUserId = "fk_user_id"
    }
}
