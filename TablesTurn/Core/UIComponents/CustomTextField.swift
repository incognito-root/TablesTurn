import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var iconName: String?
    var borderRadius: CGFloat = 50
    var paddingValue: CGFloat = 16
    var backgroundColor: Color? = nil
    var borderColor: Color? = nil
    var iconColor: Color? = nil
    var textColor: Color? = nil
    var placeHolderColor: Color? = nil
    
    var validation: ((String) -> String?)? = nil
    
    var formatter: ((String) -> String)? = nil
    
    @State private var errorMessage: String? = nil
    @State private var showError: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .foregroundColor(iconColor ?? .gray)
                }
                
                if isSecure {
                    SecureField("", text: $text, prompt: Text(placeholder).foregroundStyle(placeHolderColor ?? .gray))
                        .keyboardType(keyboardType)
                        .foregroundColor(textColor ?? .white)
                        .onChange(of: text) { newValue, _ in
                            handleChange(newValue)
                        }
                } else {
                    TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(placeHolderColor ?? .gray))
                        .keyboardType(keyboardType)
                        .foregroundColor(textColor ?? .white)
                        .onChange(of: text) { newValue, _ in
                            handleChange(newValue)
                        }
                }
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                        errorMessage = nil
                        showError = false
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundColor(iconColor ?? .gray)
                    }
                }
            }
            .padding(paddingValue)
            .background(
                RoundedRectangle(cornerRadius: borderRadius)
                    .fill(backgroundColor ?? .clear) // Apply background properly
            )
            .overlay(
                RoundedRectangle(cornerRadius: borderRadius)
                    .stroke(showError ? Color.red : borderColor ?? Color.accentColor, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: borderRadius))
            
            if let error = errorMessage, showError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.leading, 20)
            }
        }
    }
    
    private func handleChange(_ newValue: String) {
        var updatedText = newValue
        
        if let formatter = formatter {
            updatedText = formatter(updatedText)
            if updatedText != text {
                text = updatedText
                return
            }
        }
        
        if let validation = validation {
            if let error = validation(updatedText) {
                errorMessage = error
                showError = true
            } else {
                errorMessage = nil
                showError = false
            }
        }
    }
}
