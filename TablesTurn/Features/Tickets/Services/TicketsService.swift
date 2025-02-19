import Foundation
import Alamofire

@MainActor
class TicketsService {
    private let sharedService: SharedServiceProtocol
    
    init(sharedService: SharedServiceProtocol = SharedService.shared) {
        self.sharedService = sharedService
    }
    
    func redeemTicket(ticketId: String) async throws -> EventTicket {
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.redeemTicket + ticketId + "/redeem",
            method: .post
        )
    }
    
    func getUserRsvps() async throws -> [EventRsvp] {
        return try await sharedService.getUserRsvps()
    }
}
