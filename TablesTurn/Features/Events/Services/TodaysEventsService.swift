import Foundation

@MainActor
class TodaysEventsService {
    private let sharedService: SharedServiceProtocol
    
    init(sharedService: SharedServiceProtocol = SharedService.shared) {
        self.sharedService = sharedService
    }
    
    func getTodaysEvents() async throws -> [Event] {
        try await sharedService.getTodaysEvents()
    }
}
