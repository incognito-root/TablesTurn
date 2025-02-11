import Foundation
import Combine

class AddEventViewModel: ObservableObject {
    // Input fields
    @Published var title: String = ""
    @Published var timezone: String = ""
    @Published var rsvpDeadline: Date = Date()
    @Published var location: String = ""
    @Published var image: String = ""
    @Published var description: String = ""
    @Published var dateTime: Date = Date()
    @Published var date: Date = Date()
    @Published var time: Date = Date()
    
    // UI state
    @Published var currentStep: Int = 0
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var editing: Bool = false
    
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
}
