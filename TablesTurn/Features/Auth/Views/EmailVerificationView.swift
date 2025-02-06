import SwiftUI

struct EmailVerificationView: View {
    let radius: CGFloat = 50
    
    @State private var otp: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedField: Int?
    
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
                            Text("Enter the code you received\n")
                            + Text("on your email")
                                .foregroundStyle(.accent)
                        )
                        .font(.system(size: 43))
                        .fontWeight(.medium)
                        
                        HStack(spacing: 10) {
                            ForEach(0..<6, id: \.self) { index in
                                TextField("", text: $otp[index])
                                    .frame(width: 50, height: 50)
                                    .background(Color.clear) // Transparent background
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.accent, lineWidth: 2) // Add a border
                                    )
                                    .multilineTextAlignment(.center)
                                    .keyboardType(.numberPad)
                                    .focused($focusedField, equals: index)
                                    .onChange(of: otp[index]) { oldValue, newValue in
                                        if newValue.count > 1 {
                                            otp[index] = String(newValue.prefix(1))
                                        }
                                        if newValue.count == 1 && index < 5 {
                                            focusedField = index + 1
                                        }
                                    }
                            }
                        }
                        
                        Button(action: {
                            let enteredOTP = otp.joined()
                            print("Entered OTP: \(enteredOTP)")
                        }) {
                            Text("Verify".uppercased())
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                    .padding(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 20))
                }
                .padding(.top, 20)
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
