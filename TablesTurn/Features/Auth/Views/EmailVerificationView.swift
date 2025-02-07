import SwiftUI

struct EmailVerificationView: View {
    let radius: CGFloat = 50
    @FocusState private var focusedField: Int?
    
    @StateObject var viewModel = EmailVerificationViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.accentColor
                    .ignoresSafeArea()
                
                ZStack(alignment: .topLeading) {
                    Color.primaryBackground
                        .ignoresSafeArea()
                        .padding(.bottom, radius)
                        .cornerRadius(radius)
                        .padding(.bottom, -radius)
                    
                    VStack(alignment: .leading, spacing: 40) {
                        (
                            Text("Email Verification\n")
                            + Text("Enter the code you recieved")
                                .foregroundStyle(.accent)
                        )
                        .font(.system(size: 43))
                        .fontWeight(.medium)
                        
                        HStack(spacing: 10) {
                            ForEach(0..<6, id: \.self) { index in
                                TextField("", text: $viewModel.otp[index])
                                    .frame(width: 50, height: 50)
                                    .background(Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.accent, lineWidth: 2)
                                    )
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .focused($focusedField, equals: index)
                                    .onChange(of: viewModel.otp[index]) { oldValue, newValue in
                                        if newValue.count > 1 {
                                            viewModel.otp[index] = String(newValue.prefix(1))
                                        }
                                        if newValue.count == 1 && index < 5 {
                                            viewModel.focusedField = index + 1
                                        }
                                    }
                            }
                        }
                        
                        Button(action: {
                            viewModel.verifyOTP()
                        }) {
                            Text("Verify".uppercased())
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                    .padding(EdgeInsets(top: 45, leading: 20, bottom: 30, trailing: 20))
                }
                .padding(.top, 20)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            .foregroundStyle(.primaryText)
        }
        .navigationBarHidden(true)
    }
}

struct EmailVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerificationView()
    }
}
