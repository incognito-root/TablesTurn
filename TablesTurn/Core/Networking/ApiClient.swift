import Foundation
import Alamofire

enum APIError: Error {
    case invalidResponse
    case decodingError
    case serverError(String)
}

struct ApiResponse<T: Decodable>: Decodable {
    let status: String
    let data: T
    let message: String
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
            .responseDecodable(of: ApiResponse<T>.self) { response in
                switch response.result {
                case .success(let apiResponse):
                    completion(.success(apiResponse.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
