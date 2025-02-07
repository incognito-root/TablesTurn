import Foundation
import Alamofire

class EmailVerificationService {
    
    func verifyOtp(details: EmailVerificationDetails, completion: @escaping (Result<EmailVerificationResponse, Error>) -> Void) {
        let parameters: [String: Any] = [
            "userId": details.userId,
            "otp": details.otp
        ]
        
        NetworkManager.shared.request(
            endpoint: APIEndpoints.emailVerification,
            method: .post,
            parameters: parameters,
            headers: nil
        ) { (result: Result<EmailVerificationResponse, Error>) in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
