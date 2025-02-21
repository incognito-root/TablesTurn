import Foundation

protocol SharedServiceProtocol {
    func getAllEvents(searchKey: String?,
                      sortByDate: String?,
                      page: Int?,
                      pageSize: Int?) async throws -> GetAllEventsResponse
    func getUserDetails() async throws -> UserDetails
    func uploadEventImage(event: Event) async throws -> SimpleEventDetails
    func uploadUserProfileImage(user: UserDetails) async throws -> UserDetails
    func getEventsInMonth(year: String, month: Int) async throws -> [Event]
    func getEventRsvpStatuses() async throws -> [RsvpStatus]
    func getUserRsvps() async throws -> [EventRsvp]
    func getTodaysEvents() async throws -> [Event]
}
