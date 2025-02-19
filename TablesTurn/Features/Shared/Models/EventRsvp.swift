import Foundation

struct EventRsvp: Codable, Identifiable {
    let id: String
    let status: Bool
    let createdAt: Date
    let updatedAt: Date
    let fkEventId: String
    let fkStatusId: String
    let fkUserId: String
    let attendees: Int
    let user: User?
    let rsvpStatus: RsvpStatus
    let tickets: [EventTicket]?
    let event: Event

    enum CodingKeys: String, CodingKey {
        case id, status, attendees
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case fkEventId = "fk_event_id"
        case fkStatusId = "fk_status_id"
        case fkUserId = "fk_user_id"
        case rsvpStatus = "rsvp_statuses"
        case user = "users"
        case tickets
        case event = "events"
    }
}
