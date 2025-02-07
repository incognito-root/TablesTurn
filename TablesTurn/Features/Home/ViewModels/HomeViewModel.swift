import Foundation

class HomeViewModel: ObservableObject {
    @Published var searchKey: String = ""
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
}
