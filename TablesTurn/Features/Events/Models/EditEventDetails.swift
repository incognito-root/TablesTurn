import Foundation

struct EditEventDetails: Codable {
    let title: String
    let rsvpDeadline: String?
    let location: String
    let image: String?
    let description: String
    let dateTime: String

    enum CodingKeys: String, CodingKey {
        case title
        case rsvpDeadline = "rsvp_deadline"
        case location
        case image
        case description
        case dateTime = "date_time"
    }
}
