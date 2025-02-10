protocol SharedServiceProtocol {
    func getAllEvents(completion: @escaping (Result<[Event], Error>) -> Void)
    
    func getUserDetails(completion: @escaping (Result<UserDetails, Error>) -> Void)
}
