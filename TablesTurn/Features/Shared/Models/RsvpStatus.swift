import Foundation

struct RsvpStatus: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let createdAt: Date
    let updatedAt: Date
    let attendingEvent: Bool

    enum CodingKeys: String, CodingKey {
        case id, title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case attendingEvent = "attending_event"
    }
}
