import SwiftUI
import CodeScanner

struct QRScannerView: View {
    @ObservedObject var viewModel: TicketsViewModel
    
    @State private var isShowingScanner = false
    @State private var scannedCode: String?
    @State private var errorMessage: String?
    @State private var navigateToTicketDetails = false // State for navigation
    
    var redeeming: Bool?
    var buttonText: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(buttonText?.capitalized ?? "") {
                    isShowingScanner = true
                }
                .buttonStyle(MainButtonStyle(
                    fontSize: 18
                ))
                
                // NavigationLink to TicketDetailsView
                NavigationLink(
                    destination: TicketDetailsView(vm: viewModel),
                    isActive: $navigateToTicketDetails
                ) {
                    EmptyView() // Invisible navigation link
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                scannerSheet
            }
            .alert("Error", isPresented: .constant(errorMessage != nil)) {
                Button("OK", role: .cancel) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }
    
    private var scannerSheet: some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: handleScanResult
        )
        .ignoresSafeArea()
    }
    
    private func handleScanResult(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            if let jsonData = result.string.data(using: .utf8) {
                do {
                    let ticket = try JSONDecoder().decode(QrData.self, from: jsonData)
                    scannedCode = ticket.ticketId
                    
                    if let scannedCode = scannedCode {
                        viewModel.ticketId = scannedCode
                        Task {
                            if redeeming == true {
                                await viewModel.redeemTicket()
                            } else {
                                await viewModel.getTicketDetails()
                                // Navigate to TicketDetailsView after fetching details
                                DispatchQueue.main.async {
                                    navigateToTicketDetails = true
                                }
                            }
                        }
                    } else {
                        print("No value found")
                    }
                } catch {
                    errorMessage = "Failed to decode QR code data: \(error.localizedDescription)"
                }
            } else {
                errorMessage = "Invalid QR code data"
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}
