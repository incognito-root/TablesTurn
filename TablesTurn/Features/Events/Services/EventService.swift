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
            "timezone": eventDetails.timezone,
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
    
    // Async version of image upload
    func uploadEventImage(event: Event, imageData: Data) async throws -> String {
//        try await withCheckedThrowingContinuation { continuation in
//            sharedService.uploadEventImage(event: event) { result in
//                continuation.resume(with: result)
//            }
//        }
        
        return "abc"
    }
}
