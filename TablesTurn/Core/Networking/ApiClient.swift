import Foundation
import Alamofire

enum APIError: Error {
    case invalidResponse
    case decodingError
    case serverError(String)
    case emailNotVerified(userId: String?)
}

struct ApiResponse<T: Decodable>: Decodable {
    let status: String
    let data: T?
    let message: String?
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let baseURL = "https://tablesturn.co/api/"
    
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.httpCookieAcceptPolicy = .always
        return Session(configuration: configuration)
    }()
    
    private func configuredDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        // Create an ISO8601DateFormatter that supports fractional seconds.
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = isoFormatter.date(from: dateString) {
                return date
            }
            
            // Throw an error if the date string cannot be parsed.
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Cannot decode date string: \(dateString)")
        }
        return decoder
    }
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        let url = "\(baseURL)\(endpoint)"
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(url, method: method, parameters: parameters,
                            encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: ApiResponse<T>.self, decoder: configuredDecoder()) { response in
                switch response.result {
                case .success(let apiResponse):
                    if let data = apiResponse.data {
                        continuation.resume(returning: data)
                    } else {
                        let errorMessage = apiResponse.message ?? "Unknown server error"
                        continuation.resume(throwing: APIError.serverError(errorMessage))
                    }
                case .failure(let error):
                    if let data = response.data {
                        do {
                            let apiErrorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
                            
                            if let isEmailVerified = apiErrorResponse.data?.isEmailVerified, !isEmailVerified {
                                let id = apiErrorResponse.data?.userId
                                continuation.resume(throwing: APIError.emailNotVerified(userId: id))
                            } else {
                                let errorMessage = apiErrorResponse.message ??
                                apiErrorResponse.errorDetails?.message ?? "Unknown error occurred"
                                
                                if errorMessage == "Access denied. No token provided." {
                                    UserManager.shared.logout()
                                }
                                
                                continuation.resume(throwing: APIError.serverError(errorMessage))
                            }
                        } catch {
                            continuation.resume(throwing: APIError.decodingError)
                        }
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    // Async version of upload
    func upload<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .post,
        imageData: Data,
        imageFieldName: String,
        fileName: String,
        mimeType: String = "image/jpeg",
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        let url = "\(baseURL)\(endpoint)"
        
        return try await withCheckedThrowingContinuation { continuation in
            session.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageData,
                                         withName: imageFieldName,
                                         fileName: fileName,
                                         mimeType: mimeType)
            }, to: url, method: method, headers: headers)
            .validate()
            .responseDecodable(of: ApiResponse<T>.self, decoder: configuredDecoder()) { response in
                switch response.result {
                case .success(let apiResponse):
                    if let data = apiResponse.data {
                        continuation.resume(returning: data)
                    } else {
                        let errorMessage = apiResponse.message ?? "Unknown server error"
                        continuation.resume(throwing: APIError.serverError(errorMessage))
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
