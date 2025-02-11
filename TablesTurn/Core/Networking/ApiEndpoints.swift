import Foundation

struct APIEndpoints {
    // auth APIs
    static private let authPrefix = "auth/"
    static let signup = authPrefix + "register"
    static let login = authPrefix + "login"
    static let emailVerification = authPrefix + "otp/verify"

    // events APIs
    static private let eventsPrefix = "events/"
    static let getAllEvents = eventsPrefix
    static let createNewEvent = eventsPrefix
    static let rsvp = "events/rsvp"
    
    // user APIs
    static private let usersPrefix = "users/"
    static let getUserDetails = usersPrefix + "details"
}
