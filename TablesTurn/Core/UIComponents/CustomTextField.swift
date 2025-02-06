import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var iconName: String?
    var borderRadius: CGFloat = 50
    var paddingValue: CGFloat = 16
    
    var validation: ((String) -> String?)? = nil
    
    var formatter: ((String) -> String)? = nil
    
    @State private var errorMessage: String? = nil
    @State private var showError: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .foregroundColor(.gray)
                }
                
                if isSecure {
                    SecureField("", text: $text, prompt: Text(placeholder).foregroundStyle(.gray))
                        .keyboardType(keyboardType)
                        .onChange(of: text) { newValue, _ in
                            handleChange(newValue)
                        }
                } else {
                    TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(.gray))
                        .keyboardType(keyboardType)
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
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(paddingValue)
            .background(
                RoundedRectangle(cornerRadius: max(0, borderRadius))
                    .stroke(showError ? Color.red : Color.accentColor, lineWidth: 1.5)
                    .background(Color.clear)
            )
            
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
        
        // Apply formatting if a formatter is provided.
        if let formatter = formatter {
            updatedText = formatter(updatedText)
            // Avoid reassigning if the text is already formatted.
            if updatedText != text {
                text = updatedText
                return // Return early to prevent validation on stale text.
            }
        }
        
        // Apply validation if provided.
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
