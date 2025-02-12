import Foundation
import Alamofire

class SharedService: SharedServiceProtocol {
    static let shared = SharedService()
    private init() {}
    
    func getAllEvents() async throws -> [Event] {
        try await NetworkManager.shared.request(
            endpoint: APIEndpoints.getAllEvents,
            method: .get
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
}

enum ImageError: Error {
    case invalidImage
}
