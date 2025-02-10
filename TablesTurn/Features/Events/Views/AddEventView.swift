import SwiftUI

struct AddEventView: View {
    let radius: CGFloat = 50
    
    @StateObject private var viewModel = AddEditEventViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.white)]
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor(.accentColor),
            .font: UIFont.systemFont(ofSize: 24, weight: .semibold)
        ]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.secondaryBackground, .accentColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ZStack(alignment: .topLeading) {
                    Color.primaryBackground
                        .ignoresSafeArea()
                        .padding(.bottom, radius)
                        .cornerRadius(radius)
                        .padding(.bottom, -radius)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        if viewModel.currentStep == 1 {
                            (
                                Text("Enter Your Email\n")
                                + Text("To Get Started")
                                    .foregroundStyle(.accent)
                            )
                            .font(.system(size: 43))
                            .fontWeight(.medium)
                            .padding(EdgeInsets(top: 20, leading: 25, bottom: 0, trailing: 25))
                            
                            Form {
                                Section {
                                    CustomTextField(
                                        placeholder: "Email",
                                        text: $viewModel.title,
                                        keyboardType: .emailAddress,
                                        iconName: "envelope",
                                        validation: { input in
                                            if input.isEmpty {
                                                return "Email cannot be empty."
                                            }
                                            if !input.contains("@") {
                                                return "Please enter a valid email."
                                            }
                                            return nil
                                        }
                                    )
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 20, trailing: 5))
                                }
                                
                                Section {
                                    Button(action: {
                                    }) {
                                        Text("Next".uppercased())
                                    }
                                    .buttonStyle(MainButtonStyle())
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                        } else {
                            (
                                Text("Almost There!")
                            )
                            .font(.system(size: 43))
                            .fontWeight(.medium)
                            .padding(EdgeInsets(top: 20, leading: 32, bottom: 5, trailing: 25))
                            
                            Form {
                                
                            }
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                }
                .padding(.top, 20)
            }
            .foregroundStyle(.primaryText)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Craft Event")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}

#Preview {
    AddEventView()
}
