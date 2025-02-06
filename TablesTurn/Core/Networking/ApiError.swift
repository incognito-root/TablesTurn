import Foundation

struct APIErrorResponse: Decodable, Error {
    let status: String
    let message: String?
    let stack: String?
    let errorName: String?
    let errorDetails: ErrorDetails?
    let data: ErrorData?
}

struct ErrorData: Decodable {
    let userId: String
    let isEmailVerified: Bool?
}

struct ErrorDetails: Decodable {
    let name: String?
    let message: String?
    let stack: String?
    let isOperational: Bool?
    let isBadRequest: Bool?
}
