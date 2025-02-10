import Foundation
import Alamofire

class SharedService: SharedServiceProtocol {
    static let shared = SharedService()
    private init() {}
    
    func getAllEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        NetworkManager.shared.request(
            endpoint: APIEndpoints.getAllEvents,
            method: .get,
            headers: nil
        ) { (result: Result<[Event], Error>) in
            switch result {
            case .success(let events):
                completion(.success(events))
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getUserDetails(completion: @escaping (Result<UserDetails, any Error>) -> Void) {
        NetworkManager.shared.request(
            endpoint: APIEndpoints.getUserDetails,
            method: .get,
            headers: nil
        ) { (result: Result<UserDetails, Error>) in
            switch result {
            case .success(let userDetails):
                print(userDetails)
                completion(.success(userDetails))
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
