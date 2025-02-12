import Foundation

protocol SharedServiceProtocol {
    func getAllEvents(completion: @escaping (Result<[Event], Error>) -> Void)
    
    func getUserDetails(completion: @escaping (Result<UserDetails, Error>) -> Void)
    
    func uploadEventImage(eventTitle: String, fileName: String, completion: @escaping (Result<String, Error>) -> Void)
    
    func createMultipartBody(imageData: Data,
                             boundary: String,
                             fileFieldName: String,
                             fileName: String,
                             mimeType: String) -> Data
}
