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
    static let getTodaysEvents = eventsPrefix + "today"
    static let createNewEvent = eventsPrefix
    static let eventDetails = eventsPrefix
    static let getUserEvents = eventsPrefix + "user/"
    
    // user APIs
    static private let usersPrefix = "users/"
    static let getUserDetails = usersPrefix + "details"
    static let updateUserDetails = usersPrefix + "details"
    
    // upload APIs
    static private let uploadPrefix = "images/"
    static let uploadEventImage = uploadPrefix + "events/"
    
    // RSVP APIs
    static private let rsvpPrefix = "rsvp/"
    static let recentRsvpImages = rsvpPrefix + "recent/images/"
    static let RsvpToEvent = rsvpPrefix + "/"
    static let getRsvpStatus = rsvpPrefix + "statuses"
    static let getUserRsvps = rsvpPrefix + "user"
    
    // ticket APIs
    static private let ticketsPrefix = "tickets/"
    static let redeemTicket = ticketsPrefix
    static let getTicketDetails = ticketsPrefix
}
