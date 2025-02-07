import Foundation
import Combine

struct User: Codable {
    let id: String
}

final class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var currentUser: User?
    
    private let userDefaultsKey = "currentUser"
    
    private init() {
        loadUser()
    }
    
    private func loadUser() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            currentUser = nil
            return
        }
        do {
            currentUser = try JSONDecoder().decode(User.self, from: data)
        } catch {
            print("Failed to decode user: \(error)")
            currentUser = nil
        }
    }
    
    func saveUser(_ user: User) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
            currentUser = user
        } catch {
            print("Failed to encode user: \(error)")
        }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        currentUser = nil
    }
}
