import Foundation
import Alamofire

class SharedService: SharedServiceProtocol {
    static let shared = SharedService()
    private init() {}
    
    func getAllEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        NetworkManager.shared.request(
            endpoint: APIEndpoints.getAllEvents,
            method: .get,
            headers: nil
        ) { (result: Result<[Event], Error>) in
            switch result {
            case .success(let events):
                completion(.success(events))
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getUserDetails(completion: @escaping (Result<UserDetails, any Error>) -> Void) {
        NetworkManager.shared.request(
            endpoint: APIEndpoints.getUserDetails,
            method: .get,
            headers: nil
        ) { (result: Result<UserDetails, Error>) in
            switch result {
            case .success(let userDetails):
                print(userDetails)
                completion(.success(userDetails))
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func uploadEventImage(eventTitle: String, fileName: String, completion: @escaping (Result<String, any Error>) -> Void) {
        guard let uiImage = ImagePickerViewModel.underlyingImage,
                  let imageData = uiImage.jpegData(compressionQuality: 0.8) else {
                    print("invali image selected")
                return
            }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        let body = createMultipartBody(imageData: imageData, boundary: boundary)
        
        NetworkManager.shared.upload(
            endpoint: APIEndpoints.getUserDetails,
            method: .post,
            imageData: body,
            imageFieldName: "event_image",
            fileName: "image_name",
            headers: nil
        ) { (result: Result<String, Error>) in
            switch result {
            case .success(let res):
                print(res)
                completion(.success(res))
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
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

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
