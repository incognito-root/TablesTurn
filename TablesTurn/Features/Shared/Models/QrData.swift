import Foundation

struct QrData: Codable, Identifiable {
    let ticketId: String
    
    var id: String {
        return ticketId
    }
    
    enum CodingKeys: String, CodingKey {
        case ticketId
    }
}
