import Foundation

struct RsvpStatus: Codable, Identifiable, Hashable {
    let rsvpId: String
    let title: String
    let createdAt: Date
    let updatedAt: Date
    let attendingEvent: Bool

    var id: String {
        return rsvpId
    }

    enum CodingKeys: String, CodingKey {
        case rsvpId = "id"
        case title
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case attendingEvent = "attending_event"
    }
}
