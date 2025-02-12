// ImagePickerViewModel.swift
import SwiftUI
import PhotosUI
import Combine

enum ImageState: Equatable {
    case empty
    case loading(Progress)
    case success(Image)
    case failure(String)
    
    static func == (lhs: ImageState, rhs: ImageState) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case (.loading, .loading): return true
        case (.success, .success): return true
        case (.failure(let lhsError), .failure(let rhsError)): return lhsError == rhsError
        default: return false
        }
    }
}

final class ImagePickerViewModel: ObservableObject {
    @Published var imageState: ImageState = .empty
    @Published var imageSelection: PhotosPickerItem? {
        didSet {
            handleImageSelection(imageSelection)
        }
    }
    static var underlyingImage: UIImage?
    
    private var currentProgress: Progress?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    func cancelLoading() {
        currentProgress?.cancel()
        imageState = .empty
        imageSelection = nil
    }
}

private extension ImagePickerViewModel {
    func setupBindings() {
        $imageSelection
            .removeDuplicates()
            .sink { [weak self] newItem in
                guard let self else { return }
                if newItem == nil {
                    self.imageState = .empty
                }
            }
            .store(in: &cancellables)
    }
    
    func handleImageSelection(_ selection: PhotosPickerItem?) {
        guard let selection else {
            imageState = .empty
            return
        }
        
        let progress = loadTransferable(from: selection)
        currentProgress = progress
        imageState = .loading(progress)
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Data.self) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard imageSelection == self.imageSelection else {
                    self.imageState = .failure("Selection changed during load")
                    return
                }
                switch result {
                case .success(let optionalData):
                    // Unwrap the optional Data
                    guard let data = optionalData else {
                        self.imageState = .failure("No image data was returned.")
                        return
                    }
                    #if canImport(UIKit)
                    guard let uiImage = UIImage(data: data) else {
                        self.imageState = .failure("Could not convert data to UIImage")
                        return
                    }
                    ImagePickerViewModel.underlyingImage = uiImage
                    self.imageState = .success(Image(uiImage: uiImage))
                    #else
                    // Handle macOS conversion as needed.
                    #endif
                    
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    func handleError(_ error: Error) {
        let errorMessage: String
        
        switch error {
        case let error as LocalizedError where error.errorDescription != nil:
            errorMessage = error.errorDescription!
        case let error as NSError:
            errorMessage = error.localizedDescription
        default:
            errorMessage = "Unknown error occurred"
        }
        
        imageState = .failure(errorMessage)
    }
}
