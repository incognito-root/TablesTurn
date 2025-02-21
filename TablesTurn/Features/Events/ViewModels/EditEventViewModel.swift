import Foundation
import Combine

@MainActor
class EditEventViewModel: ObservableObject {
    // Input fields
    @Published var eventId: String = ""
    @Published var eventDetails: EventDetails? = nil
    @Published var title: String = ""
    @Published var location: String = ""
    @Published var image: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var time: Date = Date()
    @Published var rsvpDeadlineDate: Date = Date()
    
    // UI state
    @Published var currentStep: Int = 0
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var editing: Bool = false
    @Published var isLoading: Bool = false
    @Published var showSuccessModal = false
    
    private let eventService = EventService()
    
    // MARK: - Business Logic
    
    func reset() {
        title = ""
        location = ""
        image = ""
        description = ""
        date = Date()
        time = Date()
        rsvpDeadlineDate = Date()
        currentStep = 0
        showAlert = false
        alertMessage = ""
        editing = false
        isLoading = false
    }
    
    var minDate: Date {
        Calendar.current.date(byAdding: .day, value: 0, to: Date())!
    }
    
    var combinedDateTime: Date? {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponents = DateComponents()
        mergedComponents.year = dateComponents.year
        mergedComponents.month = dateComponents.month
        mergedComponents.day = dateComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        mergedComponents.second = timeComponents.second
        
        return calendar.date(from: mergedComponents)
    }
    
    var iso8601DateString: String? {
        guard let combined = combinedDateTime else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: combined)
    }
    
    var combinedRsvpDeadlineDate: Date? {
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        var mergedComponents = DateComponents()
        mergedComponents.year = dateComponents.year
        mergedComponents.month = dateComponents.month
        mergedComponents.day = dateComponents.day
        
        return calendar.date(from: mergedComponents)
    }
    
    var iso8601RsvpDateString: String? {
        guard let combined = combinedRsvpDeadlineDate else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.string(from: combined)
    }
    
    func getEventDetails() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            eventDetails = try await eventService.getEventDetails(eventId: eventId)
            
            // Populate the fields with fetched data
            if let details = eventDetails {
                title = details.title
                location = details.location
                description = details.description
                image = details.image ?? ""
            }
        } catch let error as APIError {
            handleAPIError(error: error)
        } catch {
            handleGenericError(error: error)
        }
    }
    
    func editEvent() async {
        await MainActor.run {
            isLoading = true
        }
        
        // Validation checks
        guard validateFields() else {
            await MainActor.run {
                isLoading = false
            }
            return
        }
        
        let eventData = EditEventDetails(
            title: self.title,
            rsvpDeadline: self.iso8601RsvpDateString ?? "",
            location: self.location,
            image: self.image,
            description: self.description,
            dateTime: self.iso8601DateString ?? ""
        )
        
        do {
            let event = try await eventService.editEvent(eventDetails: eventData, eventId: eventId)
            
            await MainActor.run {
                isLoading = false
            }
        } catch let error as APIError {
            await MainActor.run {
                handleAPIError(error: error)
                isLoading = false
            }
        } catch {
            await MainActor.run {
                handleGenericError(error: error)
                isLoading = false
            }
        }
    }
    
    private func validateFields() -> Bool {
        guard let _ = iso8601DateString,
              !title.isEmpty,
              !location.isEmpty,
              !description.isEmpty
        else {
            setAlert(message: "All fields are required.")
            return false
        }
        return true
    }
    
    private func handleAPIError(error: APIError) {
        switch error {
        case .serverError(let message):
            setAlert(message: message)
        case .decodingError:
            setAlert(message: "Failed to process server response.")
        case .invalidResponse:
            setAlert(message: "Invalid response from server.")
        case .emailNotVerified:
            print("Email not verified")
        }
    }
    
    private func handleGenericError(error: Error) {
        setAlert(message: error.localizedDescription)
    }
    
    private func setAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}
