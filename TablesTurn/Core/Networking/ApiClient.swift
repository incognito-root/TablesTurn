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
    
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let url = "\(baseURL)\(endpoint)"
        
        session.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let apiResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: data)
                        if let responseData = apiResponse.data {
                            completion(.success(responseData))
                        } else {
                            let errorMessage = apiResponse.message ?? "Unknown server error"
                            completion(.failure(APIError.serverError(errorMessage)))
                        }
                    } catch {
                        completion(.failure(APIError.decodingError))
                    }
                    
                case .failure(let error):
                    if let data = response.data {
                        do {
                            let apiErrorResponse = try JSONDecoder().decode(APIErrorResponse.self, from: data)
                            
                            if let isEmailVerified = apiErrorResponse.data?.isEmailVerified, !isEmailVerified {
                                let id = apiErrorResponse.data?.userId
                                completion(.failure(APIError.emailNotVerified(userId: id)))
                            } else {
                                let errorMessage = apiErrorResponse.message ?? apiErrorResponse.errorDetails?.message ?? "Unknown error occurred"
                                completion(.failure(APIError.serverError(errorMessage)))
                            }
                        } catch {
                            completion(.failure(APIError.decodingError))
                        }
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
}
