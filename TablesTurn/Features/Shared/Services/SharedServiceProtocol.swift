import Foundation

protocol SharedServiceProtocol {
    func getAllEvents(searchKey: String?,
                      sortByDate: String?,
                      page: Int?,
                      pageSize: Int?) async throws -> GetAllEventsResponse
    func getUserDetails() async throws -> UserDetails
    func uploadEventImage(event: Event) async throws -> String
    func getEventsInMonth(year: String, month: Int) async throws -> [Event]
    func getEventRsvpStatuses() async throws -> [RsvpStatus]
}
