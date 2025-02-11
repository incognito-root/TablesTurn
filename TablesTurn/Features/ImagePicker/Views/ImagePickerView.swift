import SwiftUI
import PhotosUI

struct ImagePickerView: View {
    @StateObject private var viewModel = ImagePickerViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // Display content based on the image state.
            switch viewModel.imageState {
            case .empty:
                // Optionally, you could show a placeholder here.
                EmptyView()
                
            case .loading(let progress):
                ProgressView(progress)
                Text("Loading...")
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10) // Rounded corners for the image preview
                
            case .failure(let errorMessage):
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
            
            // Show Reset button if there is an image selected, loading in progress, or error state.
            if case .empty = viewModel.imageState {
                // When empty, show the PhotosPicker button to select an image.
                PhotosPicker(selection: $viewModel.imageSelection, matching: .images) {
                    Text("Select Image")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            } else {
                // Otherwise, display a reset button.
                Button(action: {
                    viewModel.cancelLoading()  // This method resets the imageState and imageSelection
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
