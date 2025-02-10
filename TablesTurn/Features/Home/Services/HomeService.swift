import Foundation
import Alamofire

class HomeService {
    private let sharedService: SharedServiceProtocol
    
    init(sharedService: SharedServiceProtocol = SharedService.shared) {
        self.sharedService = sharedService
    }
    
    func getAllEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        sharedService.getAllEvents(completion: completion)
    }
}
