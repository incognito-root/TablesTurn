import Foundation

struct EventRsvp: Codable, Identifiable {
    let id: String
    let title: String
    let createdAt: Date
    let updatedAt: Date
    let attendingEvent: Bool
    let status: Bool
    let fkEventId: String
    let fkStatusId: String
    let fkUserId: String
    let attendees: Int
    let user: User
    let rsvpStatus: RsvpStatus

    enum CodingKeys: String, CodingKey {
        case id, title, status, attendees
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case attendingEvent = "attending_event"
        case fkEventId = "fk_event_id"
        case fkStatusId = "fk_status_id"
        case fkUserId = "fk_user_id"
        case rsvpStatus = "rsvp_statuses"
        case user = "users"
    }
}
