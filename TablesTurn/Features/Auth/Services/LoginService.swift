import Foundation
import Alamofire

class LoginService {
    
    func login(userDetails: UserLoginDetails, completion: @escaping (Result<UserLoginResponse, Error>) -> Void) {
        let parameters: [String: Any] = [
            "email": userDetails.email,
            "password": userDetails.password,
            "staySignedIn": userDetails.staySignedIn
        ]
        
        NetworkManager.shared.request(
            endpoint: APIEndpoints.login,
            method: .post,
            parameters: parameters,
            headers: nil
        ) { (result: Result<UserLoginResponse, Error>) in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
