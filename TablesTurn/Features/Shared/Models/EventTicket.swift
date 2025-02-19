import Foundation

struct EventTicket: Codable, Identifiable {
    let eventId: String
    let status: Bool
    let createdAt: Date
    let updatedAt: Date
    let redeemed: Bool
    let redeemedAt: Date?
    let fkRsvpId: String
    let qrImage: String
    
    var id: String {
        return eventId
    }
    
    enum CodingKeys: String, CodingKey {
        case eventId = "id"
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case redeemed
        case redeemedAt = "redeemed_at"
        case fkRsvpId = "fk_rsvp_id"
        case qrImage = "qr_image"
    }
}
