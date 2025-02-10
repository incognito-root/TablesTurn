import Foundation
import Combine

class AddEditEventViewModel: ObservableObject {
    // Input fields
    @Published var title: String = ""
    @Published var timezone: String = ""
    @Published var rsvpDeadline: Date = Date()
    @Published var location: String = ""
    @Published var image: String = ""
    @Published var description: String = ""
    @Published var dateTime: String = ""
    
    // UI state
    @Published var currentStep: Int = 1
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var editing: Bool = false
    
    // MARK: - Business Logic
    
    
}
