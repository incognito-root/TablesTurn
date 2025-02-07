import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var formattedDate: (day: String, date: String) {
        let date = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        return (dayFormatter.string(from: date), dateFormatter.string(from: date))
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                LinearGradient(
                    gradient: Gradient(colors: [.secondaryBackground, .accentColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top) {
                        Image("LogoImage")
                        Text("Tables Turn")
                            .font(.title)
                    }
                    
                    HStack {
                        VStack {
                            Text(formattedDate.day)
                                .font(.system(size: 40))
                                .fontWeight(.semibold)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(formattedDate.date)
                                .font(.system(size: 40))
                                .fontWeight(.semibold)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 20) {
                            Image("LogoImage")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            HStack(spacing: 3) {
                                Image(systemName: "location.fill")
                                Text("Tables Turn")
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Button("Today".uppercased()) {}
                                    .buttonStyle(MainButtonStyle(
                                        maxWidth: 80,
                                        padding: 16,
                                        fontSize: 15,
                                        cornerRadius: 30,
                                        backgroundColor: .black,
                                        foregroundColor: .white,
                                        borderColor: .black,
                                        borderWidth: 2
                                    ))
                                
                                Button("Calendar".uppercased()) {}
                                    .buttonStyle(MainButtonStyle(
                                        maxWidth: 80,
                                        padding: 16,
                                        fontSize: 15,
                                        cornerRadius: 30,
                                        backgroundColor: .clear,
                                        foregroundColor: .white,
                                        borderColor: .white,
                                        borderWidth: 2
                                    ))
                            }
                            
                            HStack {
                                CustomTextField(
                                    placeholder: "Search Event",
                                    text: $viewModel.searchKey,
                                    isSecure: false,
                                    keyboardType: .default,
                                    iconName: "lock",
                                    backgroundColor: Color.inputField,
                                    borderColor: .black,
                                    iconColor: .black,
                                    textColor: .black,
                                    placeHolderColor: .black,
                                    validation: { input in
                                        if input.isEmpty {
                                            return "Password cannot be empty."
                                        }
                                        return nil
                                    }
                                )
                                .frame(maxWidth: .infinity)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 15) {
                            Button(action: {}) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20))
                            }
                            .buttonStyle(CircularButtonStyle(
                                size: 50,
                                foregroundColor: .black
                            ))
                            
                            Button(action: {}) {
                                Image(systemName: "gear")
                                    .font(.system(size: 20))
                            }
                            .buttonStyle(CircularButtonStyle(
                                size: 50,
                                foregroundColor: .black
                            ))
                        }
                        .frame(maxWidth: 50, alignment: .trailing)
                    }
                    
                }
                .ignoresSafeArea()
                .padding(20)
            }
            .foregroundStyle(.primaryText)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeView()
}
