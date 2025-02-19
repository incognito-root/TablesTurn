import SwiftUI
import CodeScanner

struct QRScannerView: View {
    @ObservedObject var viewModel: TicketsViewModel
    
    @State private var isShowingScanner = false
    @State private var scannedCode: String?
    @State private var errorMessage: String?
    var redeeming: Bool?
    var buttonText: String?
    
    var body: some View {
        VStack {
            Button(buttonText?.capitalized ?? "") {
                isShowingScanner = true
            }
            .buttonStyle(MainButtonStyle(
                fontSize: 18
            ))
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
    
    private var scannerSheet: some View {
        CodeScannerView(
            codeTypes: [.qr],
            simulatedData: #"{"ticketId":"1"}"#,  // Remove in production
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
