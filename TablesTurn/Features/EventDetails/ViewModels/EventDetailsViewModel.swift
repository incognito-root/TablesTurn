import Foundation
import Combine

@MainActor
class EventDetailsViewModel: ObservableObject {
    @Published var eventDetails: EventDetails? = nil
    @Published var eventId: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading = false

    private let eventDetailsService = EventDetailsService()
    
    init(eventId: String) {
        self.eventId = eventId
    }
    
    func formattedEventDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: eventDetails?.dateTime ?? Date())
    }

    func formattedEventRsvp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: eventDetails?.rsvpDeadline ?? Date())
    }
    
    func getEventDetails() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            eventDetails = try await eventDetailsService.getEventDetails(eventId: eventId)
        } catch let error as APIError {
            handleAPIError(error: error)
        } catch {
            handleGenericError(error: error)
        }
    }
    
    private func handleAPIError(error: APIError) {
        switch error {
        case .serverError(let message):
            alertMessage = message
        case .decodingError:
            alertMessage = "Failed to process server response."
        case .invalidResponse:
            alertMessage = "Invalid response from server."
        case .emailNotVerified:
            alertMessage = "Please verify your email first."
        }
        showAlert = true
    }
    
    private func handleGenericError(error: Error) {
        alertMessage = error.localizedDescription
        showAlert = true
    }
}
