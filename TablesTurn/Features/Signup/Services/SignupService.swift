import Foundation
import Alamofire

class SignupService {
    
    func signUp(userDetails: UserRegistrationDetails, completion: @escaping (Result<UserLoginResponse, Error>) -> Void) {
        let parameters: [String: Any] = [
            "userDetails": [
                "first_name": userDetails.firstName,
                "last_name": userDetails.lastName,
                "password": userDetails.password,
                "email": userDetails.email,
                "instagram_username": userDetails.instagramUsername ?? "",
                "twitter_username": userDetails.twitterUsername ?? "",
                "linkedin_username": userDetails.linkedinUsername ?? ""
            ]
        ]
        
        NetworkManager.shared.request(
            endpoint: APIEndpoints.signupUrl,
            method: .post,
            parameters: parameters,
            headers: nil
        ) { (result: Result<UserLoginResponse, Error>) in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                DispatchQueue.main.async {
                    showAlert(for: error)
                }
                completion(.failure(error))
            }
        }
    }
}
