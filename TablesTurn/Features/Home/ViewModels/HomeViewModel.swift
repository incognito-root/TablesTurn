import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var searchKey: String = ""
    @Published var allEventsResponse: GetAllEventsResponse? = nil
    @Published var events: [Event] = []
    @Published var userDetails: UserDetails?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading = false
    @Published var currentPage = 1
    @Published var totalPages = 1
    let pageSize = 5
    
    private let homeService = HomeService()
    private let sharedService: SharedServiceProtocol = SharedService.shared
    
    func getAllEvents() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            allEventsResponse = try await homeService.getAllEvents(page: currentPage, pageSize: pageSize)
            
            if allEventsResponse != nil && allEventsResponse?.data != nil {
                events = allEventsResponse?.data ?? []
                totalPages = allEventsResponse?.pagination.totalPages ?? 0
            }
        } catch let error as APIError {
            handleAPIError(error: error)
        } catch {
            handleGenericError(error: error)
        }
    }
    
    func getUserDetails() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            userDetails = try await sharedService.getUserDetails()
        } catch let error as APIError {
            handleAPIError(error: error)
        } catch {
            handleGenericError(error: error)
        }
    }
    
    private func handleAPIError(error: APIError) {
        switch error {
        case .serverError(let message):
            alertMessage = message
        case .decodingError:
            alertMessage = "Failed to process server response."
        case .invalidResponse:
            alertMessage = "Invalid response from server."
        case .emailNotVerified:
            alertMessage = "Please verify your email first."
        }
        showAlert = true
    }
    
    private func handleGenericError(error: Error) {
        alertMessage = error.localizedDescription
        showAlert = true
    }
}
