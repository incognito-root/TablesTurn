import Foundation

struct APIEndpoints {
    // auth APIs
    static let authPrefix = "auth/"
    static let signup = authPrefix + "signup"
    static let login = authPrefix + "login"

    static let events = "events"
    static let rsvp = "events/rsvp"
    static let profile = "user/profile"
}
