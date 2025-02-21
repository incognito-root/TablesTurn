import Foundation
import Combine

@MainActor
class TodaysEventsViewModel: ObservableObject {
    // Input fields
    @Published var events: [Event] = []
    
    // UI state
    @Published var currentStep: Int = 0
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading: Bool = false
    
    private let eventService = TodaysEventsService()
    
    // MARK: - Business Logic
    
    func getTodaysEvents() async {
        await MainActor.run {
            isLoading = true
        }
        
        do {
            let events = try await eventService.getTodaysEvents()
            
            self.events = events
            
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
