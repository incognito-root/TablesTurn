import SwiftUI

struct RootView: View {
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        Group {
            if let user = userManager.currentUser, !user.id.isEmpty {
                LoginFormView()
            } else {
                GettingStartedView()
            }
        }
    }
}
