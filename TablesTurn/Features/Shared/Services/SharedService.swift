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
}
