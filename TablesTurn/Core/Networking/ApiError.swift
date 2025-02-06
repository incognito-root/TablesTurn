import Foundation

struct APIErrorResponse: Decodable, Error {
    let status: String
    let message: String?
    let stack: String?
    let errorName: String?
    let errorDetails: ErrorDetails?
}

struct ErrorDetails: Decodable {
    let name: String?
    let message: String?
    let stack: String?
    let isOperational: Bool?
    let isBadRequest: Bool?
}
