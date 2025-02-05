import SwiftUI

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
            .background(Color.clear)
            .cornerRadius(borderRadius)
            .overlay(
                RoundedRectangle(cornerRadius: borderRadius)
                    .stroke(showError ? Color.red : Color.accentColor, lineWidth: 1)
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
        if let formatter = formatter {
            let formatted = formatter(newValue)
            if formatted != newValue {
                DispatchQueue.main.async {
                    self.text = formatted
                }
            }
        }
        
        if let validation = validation {
            if let error = validation(newValue) {
                errorMessage = error
                showError = true
            } else {
                errorMessage = nil
                showError = false
            }
        }
    }
}
