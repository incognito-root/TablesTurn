import SwiftUI

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for edge in edges {
            switch edge {
            case .top:
                path.addRect(CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom:
                path.addRect(CGRect(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading:
                path.addRect(CGRect(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing:
                path.addRect(CGRect(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }
        
        return path
    }
}

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
    var borderEdges: [Edge]? = nil
    var borderWidth: CGFloat? = nil
    
    var validation: ((String) -> String?)? = nil
    
    var formatter: ((String) -> String)? = nil
    
    @State private var errorMessage: String? = nil
    @State private var showError: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .foregroundStyle(iconColor ?? .gray)
                }
                
                if isSecure {
                    SecureField("", text: $text, prompt: Text(placeholder).foregroundStyle(placeHolderColor ?? .gray))
                        .keyboardType(keyboardType)
                        .foregroundStyle(textColor ?? .white)
                        .onChange(of: text) { newValue, _ in
                            handleChange(newValue)
                        }
                } else {
                    TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(placeHolderColor ?? .gray))
                        .keyboardType(keyboardType)
                        .foregroundStyle(textColor ?? .white)
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
                            .foregroundStyle(iconColor ?? .gray)
                    }
                }
            }
            .padding(paddingValue)
            .background(
                RoundedRectangle(cornerRadius: borderRadius)
                    .fill(backgroundColor ?? .clear)
            )
            .overlay(
                Group {
                    if let edges = borderEdges {
                        EdgeBorder(width: borderWidth ?? 1.5, edges: edges)
                            .foregroundStyle(showError ? Color.red : borderColor ?? Color.accentColor)
                    } else {
                        RoundedRectangle(cornerRadius: borderRadius)
                            .stroke(showError ? Color.red : borderColor ?? Color.accentColor, lineWidth: borderWidth ?? 1.5)
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: borderRadius))
            
            if let error = errorMessage, showError {
                Text(error)
                    .foregroundStyle(.red)
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
