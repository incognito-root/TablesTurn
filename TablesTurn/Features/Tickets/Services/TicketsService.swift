import Foundation
import Alamofire

@MainActor
class TicketsService {
    func redeemTicket(ticketId: String) async throws -> EventTicket {
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.redeemTicket + ticketId + "/redeem",
            method: .post
        )
    }
}
