import Foundation

struct RsvpDetails: Codable {
    let rsvpStatusId: Int
    let attendees: Int
    
    enum CodingKeys: String, CodingKey {
        case rsvpStatusId
        case attendees
    }
}
