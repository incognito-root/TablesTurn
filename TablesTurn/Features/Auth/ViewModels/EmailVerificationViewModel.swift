import Foundation
import Combine

class EmailVerificationViewModel: ObservableObject {
    @Published private var otp: [String] = Array(repeating: "", count: 6)
    
    
}
