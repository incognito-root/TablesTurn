import Foundation
import Combine

@MainActor
class EventDetailsViewModel: ObservableObject {
    @Published var eventDetails: EventDetails? = nil
    @Published var recentRsvpImages: [String]? = []
    @Published var eventId: String = ""
    @Published var rsvpStatuses: [RsvpStatus]? = nil
    @Published var attendees: Int = 1
    @Published var selectedRsvpStatus: RsvpStatus? = nil
    
    @Published var showRsvpModal: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading = false
    @Published var showSuccessModal = false

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
    
    func getRecentRsvpsImages() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            recentRsvpImages = try await eventDetailsService.getRecentRsvpImages(eventId: eventId)
        } catch let error as APIError {
            handleAPIError(error: error)
        } catch {
            handleGenericError(error: error)
        }
    }
    
    func getRsvpStatuses() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            rsvpStatuses = try await eventDetailsService.getRsvpStatuses()
            
            self.selectedRsvpStatus = rsvpStatuses?[0] ?? nil
        } catch let error as APIError {
            handleAPIError(error: error)
        } catch {
            handleGenericError(error: error)
        }
    }
    
    func rsvpToEvent() async {
        isLoading = true
        defer { isLoading = false }
        
        let rsvpStatusId: Int = Int(selectedRsvpStatus?.rsvpId ?? "0") ?? 0
        
        do {
            let rsvpDetails = RsvpDetails(
                rsvpStatusId: rsvpStatusId,
                attendees: self.attendees
            )
            
            try await eventDetailsService.rsvpToEvent(rsvp: rsvpDetails, eventId: self.eventId)

            await MainActor.run {
                isLoading = false
                showRsvpModal = false
                showSuccessModal = true
            }
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
