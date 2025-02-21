import Foundation
import Combine

@MainActor
class UserEventsViewModel: ObservableObject {
    // Input fields
    @Published var userEvents: [Event] = []
    
    // UI state
    @Published var currentStep: Int = 0
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var editing: Bool = false
    @Published var isLoading: Bool = false
    @Published var showSuccessModal = false
    
    private let eventService = UserEventService()
    let imagePickerViewModel = ImagePickerViewModel()
    
    // MARK: - Business Logic
    
    func getUserEvents() async {
        await MainActor.run {
            isLoading = true
        }
        
        do {
            let userEvents = try await eventService.getUserEvents()
            
            self.userEvents = userEvents
            
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
