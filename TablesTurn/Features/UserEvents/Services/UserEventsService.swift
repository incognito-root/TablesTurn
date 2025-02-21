import Foundation
import Alamofire

@MainActor
class UserEventService {
    // Async version
    func getUserEvents() async throws -> [Event] {
        
        let userId = UserManager.shared.currentUser?.id ?? ""
              
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.getUserEvents + userId,
            method: .get
        )
    }
}
