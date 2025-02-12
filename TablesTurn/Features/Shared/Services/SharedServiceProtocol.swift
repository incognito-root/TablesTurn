import Foundation

protocol SharedServiceProtocol {
    func getAllEvents() async throws -> [Event]
    func getUserDetails() async throws -> UserDetails
    func uploadEventImage(event: Event) async throws -> String
}
