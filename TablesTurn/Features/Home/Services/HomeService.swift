import Foundation

@MainActor
class HomeService {
    private let sharedService: SharedServiceProtocol
    
    init(sharedService: SharedServiceProtocol = SharedService.shared) {
        self.sharedService = sharedService
    }
    
    func getAllEvents() async throws -> [Event] {
        try await sharedService.getAllEvents()
    }
}
