import Foundation

struct APIEndpoints {
    // auth APIs
    static private let authPrefix = "auth/"
    static let signupUrl = authPrefix + "register"
    static let login = authPrefix + "login"
    static let emailVerification = authPrefix + "otp/verify"

    static let events = "events"
    static let rsvp = "events/rsvp"
    static let profile = "user/profile"
}
