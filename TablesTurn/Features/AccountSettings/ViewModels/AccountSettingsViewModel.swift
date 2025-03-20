import Foundation
import Combine

@MainActor
class AccountSettingsViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isEditing = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading = false
    @Published var showSuccessModal = false
    @Published var showDeleteConfirmationModal = false
    @Published var isDeleting = false
    @Published var deleteSuccess = false
    
    private let accountSettingsService = AccountSettingsService()
    
    func changePassword(currentPassword: String, newPassword: String) async {
        do {
            _ = try await accountSettingsService.changePassword(oldPassword: currentPassword, newPassword: newPassword)
            
            await MainActor.run {
                isLoading = false
                showSuccessModal = true
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
    
    func deleteAccount() async {
            isDeleting = true
            defer { isDeleting = false }
            
            do {
                _ = try await accountSettingsService.deleteAccount()
                deleteSuccess = true
                UserManager.shared.logout()
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
