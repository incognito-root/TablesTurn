import Foundation
import Alamofire

@MainActor
class EventDetailsService {

    func getEventDetails(eventId: String) async throws -> EventDetails {
        
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.eventDetails + eventId,
            method: .get
        )
    }
}
