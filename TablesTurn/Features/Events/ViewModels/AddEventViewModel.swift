import Foundation
import Combine

class AddEventViewModel: ObservableObject {
    // Input fields
    @Published var title: String = ""
    @Published var timezone: String = "UTC-12"
    @Published var location: String = ""
    @Published var image: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var time: Date = Date()
    @Published var rsvpDeadlineDate: Date = Date()
    
    // UI state
    @Published var currentStep: Int = 2
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var editing: Bool = false
    
    private let eventService = EventService()
    let imagePickerViewModel = ImagePickerViewModel()
    
    // MARK: - Business Logic
    
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
    
    func changeStep() {
        if currentStep == 0 {
            let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedTitle.isEmpty else {
                alertMessage = "Title is required."
                showAlert = true
                return
            }
            
            guard let eventDateTime = combinedDateTime else {
                alertMessage = "Invalid event date and time."
                showAlert = true
                return
            }
            
            if eventDateTime < Date() {
                alertMessage = "Event date and time must be in the future."
                showAlert = true
                return
            }
        } else if currentStep == 1 {
            let trimmedTimezone = timezone.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedLocation = location.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard !trimmedTimezone.isEmpty else {
                alertMessage = "Timezone is required."
                showAlert = true
                return
            }
            
            guard !trimmedLocation.isEmpty else {
                alertMessage = "Location is required."
                showAlert = true
                return
            }
            
            guard !trimmedDescription.isEmpty else {
                alertMessage = "Description is required."
                showAlert = true
                return
            }
        }
        
        currentStep += 1
    }
    
    func addEvent() {
        if iso8601DateString == nil {
            alertMessage = "All fields are required."
            showAlert = true
            return
        }
        
        guard !title.isEmpty,
              !timezone.isEmpty,
              !location.isEmpty,
              !description.isEmpty
        else {
            alertMessage = "All fields are required."
            showAlert = true
            return
        }
        
        let eventData = AddEventDetails(
            title: self.title,
            timezone: self.timezone,
            rsvpDeadline: self.iso8601RsvpDateString ?? "",
            location: self.location,
            image: "",
            description: self.description,
            dateTime: self.iso8601DateString ?? ""
        )
        
        eventService.createEvent(eventDetails: eventData) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let event):
                    print(event)
                    
                case .failure(let error):
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .serverError(let message):
                            self.alertMessage = message
                        case .decodingError:
                            self.alertMessage = "Failed to process server response."
                        case .invalidResponse:
                            self.alertMessage = "Invalid response from server."
                        case .emailNotVerified:
                            print("email not verified")
                        }
                    } else {
                        self.alertMessage = error.localizedDescription
                    }
                    self.showAlert = true
                }
            }
        }
    }
    
    
}
