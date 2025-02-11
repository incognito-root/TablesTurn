import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @StateObject private var viewModel = ImagePickerViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            switch viewModel.imageState {
            case .empty:
                EmptyView()
                
            case .loading(let progress):
                VStack {
                    ProgressView(progress)
                    Text("Loading...")
                }
                .frame(height: 180)
                
            case .success(let image):
                image
                    .resizable()
                    .frame(height: 180)
                    .scaledToFit()
                    .cornerRadius(10)
                
            case .failure(let errorMessage):
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
            
            if case .empty = viewModel.imageState {
                PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                    Text("Select Image")
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            } else {
                Button(action: {
                    viewModel.cancelLoading()
                }) {
                    Text("Reset Image")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}
