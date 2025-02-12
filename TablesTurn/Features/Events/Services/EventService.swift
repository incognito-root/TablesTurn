import Foundation
import Alamofire

class EventService {
    
    func createEvent(eventDetails: AddEventDetails, completion: @escaping (Result<Event, Error>) -> Void) {
        let parameters: [String: Any] = [
            "title": eventDetails.title,
            "timezone": eventDetails.timezone,
            "rsvp_deadline": eventDetails.rsvpDeadline ?? "",
            "image": "",
            "description": eventDetails.description,
            "date_time": eventDetails.dateTime,
            "location": eventDetails.location
        ]
        
        NetworkManager.shared.request(
            endpoint: APIEndpoints.createNewEvent,
            method: .post,
            parameters: parameters,
            headers: nil
        ) { (result: Result<Event, Error>) in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
