import SwiftUI

struct SuccessModalView: View {
    var onOK: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Event Added Successfully!")
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
