import Foundation
import Alamofire

@MainActor
class EventsCalendarService {
    private let sharedService: SharedServiceProtocol
    
    init(sharedService: SharedServiceProtocol = SharedService.shared) {
        self.sharedService = sharedService
    }

    func getEventsInMonth(year: String, month: Int) async throws -> [Event] {
        try await SharedService.shared.getEventsInMonth(year: year, month: month)
    }
}
