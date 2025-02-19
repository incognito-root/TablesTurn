import Foundation
import Combine

@MainActor
class TicketsViewModel: ObservableObject {
    @Published var ticketId: String? = nil
    @Published var redeemedTicket: EventTicket? = nil
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading = false

    private let ticketService = TicketsService()

    func redeemTicket() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            redeemedTicket = try await ticketService.redeemTicket(ticketId: self.ticketId ?? "")

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
