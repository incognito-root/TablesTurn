import SwiftUI

struct RedeemTicketView: View {
    let radius: CGFloat = 50
    
    @StateObject var viewModel = TicketsViewModel()
    
    init() {
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.white,
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
                    
                    VStack(spacing: 20) {
                        HStack {
                            Text("Redeem a Ticket or Check Details by Scanning the QR Code")
                                .font(.system(size: 35))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 20)
                        
                        QRScannerView(
                            viewModel: self.viewModel,
                            redeeming: true,
                            buttonText: "redeem ticket"
                        )
                        
                        QRScannerView(
                            viewModel: self.viewModel,
                            redeeming: false,
                            buttonText: "ticket details"
                        )
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"),
                      message: Text(viewModel.alertMessage),
                      dismissButton: .default(Text("OK")))
            }
            .foregroundStyle(.primaryText)
            .navigationTitle("Redeem Ticket")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    RedeemTicketView()
}
