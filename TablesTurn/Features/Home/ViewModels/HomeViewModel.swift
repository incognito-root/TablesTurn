import Foundation

class HomeViewModel: ObservableObject {
    @Published var searchKey: String = ""
    @Published var events: [Event] = []
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isLoading = false
    
    private let homeService = HomeService()
    
    func getAllEvents() {
        homeService.getAllEvents() { [weak self] result in
            self?.isLoading = true
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let events):
                    self.events = events
                    self.isLoading = false
                    
                case .failure(let error):
                    self.isLoading = false
                    
                    if let apiError = error as? APIError {
                        switch apiError {
                        case .serverError(let message):
                            self.alertMessage = message
                        case .decodingError:
                            self.alertMessage = "Failed to process server response."
                        case .invalidResponse:
                            self.alertMessage = "Invalid response from server."
                        case .emailNotVerified:
                            print("email not verified")
                        }
                    } else {
                        self.alertMessage = error.localizedDescription
                    }
                    self.showAlert = true
                }
            }
        }
    }
}
