import Foundation
import Alamofire

class SharedService: SharedServiceProtocol {
    static let shared = SharedService()
    private init() {}
    
    func getAllEvents(
        searchKey: String? = nil,
        sortByDate: String? = nil,
        page: Int? = nil,
        pageSize: Int? = nil
    ) async throws -> GetAllEventsResponse {
        var parameters: [String: Any] = [:]
        if let searchKey = searchKey {
            parameters["searchKey"] = searchKey
        }
        if let sortByDate = sortByDate {
            parameters["sortByDate"] = sortByDate
        }
        if let page = page {
            parameters["page"] = page
        }
        if let pageSize = pageSize {
            parameters["pageSize"] = pageSize
        }
        
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.getAllEvents,
            method: .get,
            parameters: parameters.isEmpty ? nil : parameters
        )
    }
    
    func getUserDetails() async throws -> UserDetails {
        try await NetworkManager.shared.request(
            endpoint: APIEndpoints.getUserDetails,
            method: .get
        )
    }
    
    func uploadEventImage(event: Event) async throws -> String {
        guard let uiImage = ImagePickerViewModel.underlyingImage,
              let imageData = uiImage.jpegData(compressionQuality: 0.8) else {
            throw ImageError.invalidImage
        }
        
        return try await NetworkManager.shared.upload(
            endpoint: APIEndpoints.uploadEventImage + event.id,
            method: .post,
            imageData: imageData,
            imageFieldName: "file",
            fileName: "image_\(Date().timeIntervalSince1970).jpg"
        )
    }
    
    func getEventsInMonth(year: String, month: Int) async throws -> [Event] {
        return try await NetworkManager.shared.request(
            endpoint: APIEndpoints.getAllEvents + "/" + year + "/" + String(month),
            method: .get
        )
    }
}

enum ImageError: Error {
    case invalidImage
}
