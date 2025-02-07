import SwiftUI

@main
struct TablesTurnApp: App {
    @StateObject private var userManager = UserManager.shared
    
    var body: some Scene {
        WindowGroup {
           RootView()
                .environmentObject(userManager)
        }
    }
}
