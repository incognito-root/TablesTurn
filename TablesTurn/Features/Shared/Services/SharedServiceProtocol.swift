protocol SharedServiceProtocol {
    func getAllEvents(completion: @escaping (Result<[Event], Error>) -> Void)
}
