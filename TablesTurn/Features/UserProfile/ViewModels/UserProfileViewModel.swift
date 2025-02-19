import Foundation
import Combine

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var userDetails = UserDetails(
        id: "123",
        firstName: "John",
        lastName: "Doe",
        email: "john@example.com",
        createdAt: Date(),
        status: true,
        instagramUsername: "johndoe",
        isEmailVerified: true,
        twitterUsername: nil,
        profileImage: nil,
        linkedinUsername: nil
    )
    @Published var isEditing = false
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading = false
    
    private let userProfileService = UserProfileService()
    
    func getUserDetails() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            userDetails = try await userProfileService.getUserDetails()
        } catch let error as APIError {
            handleAPIError(error: error)
        } catch {
            handleGenericError(error: error)
        }
    }
    
    func updateUserDetails() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            userDetails = try await userProfileService.updateDetails(userDetails: self.userDetails)
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
