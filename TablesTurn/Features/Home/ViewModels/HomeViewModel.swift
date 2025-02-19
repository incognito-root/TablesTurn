import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var userDetails: UserDetails?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading = false
    @Published var canLoadMore = true // To track if more data can be loaded
    
    @Published var searchKey = "" {
        didSet {
            if searchKey.count < 3 && !searchKey.isEmpty {
                // Show message or handle minimum characters
            }
        }
    }
    
    private var currentPage = 1 // Track current page internally
    private let pageSize = 5
    
    private var cancellables = Set<AnyCancellable>()
    private let homeService = HomeService()
    
    init() {
        setupSearchPublisher()
    }
    
    private func setupSearchPublisher() {
        $searchKey
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.resetAndFetchEvents()
            }
            .store(in: &cancellables)
    }
    
    // Reset events and fetch the first page
    func resetAndFetchEvents() {
        currentPage = 1
        events = []
        canLoadMore = true
        getAllEvents()
    }
    
    // Fetch initial or additional events
    func getAllEvents() {
        guard !isLoading, canLoadMore else { return }
        
        isLoading = true
        
        Task { @MainActor in
            do {
                let response = try await SharedService.shared.getAllEvents(
                    searchKey: searchKey,
                    sortByDate: "asc",
                    page: currentPage,
                    pageSize: self.pageSize
                )
                
                if currentPage == 1 {
                    events = response.data
                } else {
                    events.append(contentsOf: response.data)
                }
                
                // Check if there are more pages to load
                if response.data.count < pageSize {
                    canLoadMore = false
                } else {
                    currentPage += 1
                }
            } catch {
                alertMessage = error.localizedDescription
                showAlert = true
            }
            isLoading = false
        }
    }
    
    // Load more events for infinite scroll
    func loadMoreEvents() {
        getAllEvents()
    }
    
    func getUserDetails() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            userDetails = try await homeService.getUserDetails()
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
