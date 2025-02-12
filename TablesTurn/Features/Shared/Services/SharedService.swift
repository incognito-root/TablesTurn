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
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let body = createMultipartBody(
            imageData: imageData,
            boundary: boundary
        )
        
        return try await NetworkManager.shared.upload(
            endpoint: APIEndpoints.uploadEventImage + event.id,
            method: .post,
            imageData: body,
            imageFieldName: "event_image",
            fileName: "image_name"
        )
    }
    
    internal func createMultipartBody(
        imageData: Data,
        boundary: String,
        fileFieldName: String = "image",
        fileName: String = "image.jpg",
        mimeType: String = "image/jpeg") -> Data {
            let lineBreak = "\r\n"
            var body = Data()
            
            body.append("--\(boundary)\(lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(fileFieldName)\"; filename=\"\(fileName)\"\(lineBreak)")
            body.append("Content-Type: \(mimeType)\(lineBreak + lineBreak)")
            body.append(imageData)
            body.append(lineBreak)
            
            body.append("--\(boundary)--\(lineBreak)")
            
            return body
        }
}

enum ImageError: Error {
    case invalidImage
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
