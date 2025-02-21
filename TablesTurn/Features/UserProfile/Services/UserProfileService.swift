import Foundation
import Alamofire

@MainActor
class UserProfileService {
    private let sharedService: SharedServiceProtocol
    
    init(sharedService: SharedServiceProtocol = SharedService.shared) {
        self.sharedService = sharedService
    }
    
    func getUserDetails() async throws -> UserDetails {
        try await sharedService.getUserDetails()
    }
    
    func updateDetails(userDetails: UserDetails) async throws -> UserDetails {
        let parameters: [String: Any] = [
            "instagramUsername": userDetails.instagramUsername ?? "",
            "twitterUsername": userDetails.twitterUsername ?? "",
            "linkedinUsername": userDetails.linkedinUsername ?? "",
            "firstName": userDetails.firstName,
            "lastName": userDetails.lastName
        ]
        
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.updateUserDetails,
            method: .put,
            parameters: parameters
        )
    }
    
    func uploadUserProfileImage(userDetails: UserDetails) async throws -> UserDetails {
        try await sharedService.uploadUserProfileImage(user: userDetails)
    }
}
