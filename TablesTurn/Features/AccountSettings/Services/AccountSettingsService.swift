import Foundation
import Alamofire

@MainActor
class AccountSettingsService {
    func changePassword(oldPassword: String, newPassword: String) async throws -> String {
        let parameters: [String: Any] = [
            "oldPassword": oldPassword,
            "newPassword": newPassword
        ]
        
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.changePassword,
            method: .post,
            parameters: parameters
        )
    }
    
    func deleteAccount() async throws -> String {
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.deleteAccount,
            method: .delete
        )
    }
}
