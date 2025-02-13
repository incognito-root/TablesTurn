import Foundation

struct pagination: Codable {
    let currentPage: Int
    let pageSize: Int
    let totalItems: Int
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case currentPage, pageSize, totalItems, totalPages
    }
}

struct GetAllEventsResponse: Codable {
    let data: [Event]
    let pagination: pagination
    
    enum CodingKeys: String, CodingKey {
        case data, pagination
    }
}
