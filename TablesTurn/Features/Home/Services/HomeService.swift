import Foundation

@MainActor
class HomeService {
    private let sharedService: SharedServiceProtocol
    
    init(sharedService: SharedServiceProtocol = SharedService.shared) {
        self.sharedService = sharedService
    }
    
    func getAllEvents(searchKey: String? = nil,
                      sortByDate: String? = nil,
                      page: Int? = nil,
                      pageSize: Int? = nil) async throws -> GetAllEventsResponse {
        try await sharedService.getAllEvents(searchKey: searchKey,
                                             sortByDate: sortByDate,
                                             page: page,
                                             pageSize: pageSize)
    }
    
    func getUserDetails() async throws -> UserDetails {
        try await sharedService.getUserDetails()
    }
}
