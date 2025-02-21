import SwiftUI

struct SuccessModalView: View {
    let textToShow: String?
    var onOK: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(textToShow ?? "")
                    .font(.headline)
                    .foregroundColor(.primaryText)
                
                Button("OK") {
                    onOK()
                }
                .buttonStyle(MainButtonStyle(
                    fontSize: 20,
                    foregroundColor: .white
                )
                )
            }
            .padding()
            .background(Color.primaryBackground)
            .cornerRadius(20)
            .padding(.horizontal, 40)
        }
    }
}
