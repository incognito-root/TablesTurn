import Foundation
import Combine

@MainActor
class AddEventsCalendarViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading = false
    @Published var selectedMonthIndex: Int
    let months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN",
                  "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]

    private let eventsCalendarService = EventsCalendarService()
    
    init() {
        self.selectedMonthIndex = Calendar.current.component(.month, from: Date()) - 1
    }
    
    func getEventsByMonth() {
        guard !isLoading else { return }
        
        isLoading = true
        
        Task { @MainActor in
            do {
                let response = try await eventsCalendarService.getEventsInMonth(year: "2025", month: selectedMonthIndex)
                
                events = response
                
                print(response)
            } catch {
                alertMessage = error.localizedDescription
                showAlert = true
            }
            isLoading = false
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
