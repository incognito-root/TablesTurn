import Foundation
import Alamofire

@MainActor
class EventService {
    private let sharedService: SharedServiceProtocol
    
    init(sharedService: SharedServiceProtocol = SharedService.shared) {
        self.sharedService = sharedService
    }
    
    // Async version
    func createEvent(eventDetails: AddEventDetails) async throws -> Event {
        let parameters: [String: Any] = [
            "title": eventDetails.title,
            "rsvp_deadline": eventDetails.rsvpDeadline ?? "",
            "image": "",
            "description": eventDetails.description,
            "date_time": eventDetails.dateTime,
            "location": eventDetails.location
        ]
        
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.createNewEvent,
            method: .post,
            parameters: parameters
        )
    }

    func uploadEventImage(event: Event) async throws -> String {
        try await sharedService.uploadEventImage(event: event)
    }
}
