import Foundation
import Alamofire

@MainActor
class EventDetailsService {
    private let sharedService: SharedServiceProtocol
    
    init(sharedService: SharedServiceProtocol = SharedService.shared) {
        self.sharedService = sharedService
    }

    func getEventDetails(eventId: String) async throws -> EventDetails {
        
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.eventDetails + eventId,
            method: .get
        )
    }
    
    func getRecentRsvpImages(eventId: String) async throws -> [String] {
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.recentRsvpImages + eventId,
            method: .get
        )
    }
    
    func getRsvpStatuses() async throws -> [RsvpStatus] {
        try await sharedService.getEventRsvpStatuses()
    }
}
