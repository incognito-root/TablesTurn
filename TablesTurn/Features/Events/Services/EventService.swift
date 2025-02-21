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
    
    func editEvent(eventDetails: EditEventDetails, eventId: String) async throws -> Event {
        let parameters: [String: Any] = [
            "title": eventDetails.title,
            "rsvp_deadline": eventDetails.rsvpDeadline ?? "",
            "location": eventDetails.location,
            "image": "",
            "description": eventDetails.description,
            "date_time": eventDetails.dateTime
        ]
        
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.updateEvent + eventId,
            method: .put,
            parameters: parameters
        )
    }
    
    func getEventDetails(eventId: String) async throws -> EventDetails {
        
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.eventDetails + eventId,
            method: .get
        )
    }

    func uploadEventImage(event: Event) async throws -> SimpleEventDetails {
        try await sharedService.uploadEventImage(event: event)
    }
}
