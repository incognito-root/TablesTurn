import Foundation
import SwiftUI

func showAlert(for error: Error) {
    var errorMessage = "An unknown error occurred."
    
    if let apiError = error as? APIError {
        switch apiError {
        case .serverError(let message):
            errorMessage = message  // Extract correct error message
        case .decodingError:
            errorMessage = "Failed to process server response."
        case .invalidResponse:
            errorMessage = "Invalid response from server."
        }
    } else {
        errorMessage = error.localizedDescription
    }
    
    let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    
    DispatchQueue.main.async {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first(where: { $0.isKeyWindow }),
           let rootVC = window.rootViewController {
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
}
