// ProfileImage.swift
import SwiftUI

struct ProfileImage: Transferable {
    let image: Image
    
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
#if canImport(AppKit)
            guard let nsImage = NSImage(data: data) else {
                throw TransferError.importFailed
            }
            return ProfileImage(image: Image(nsImage: nsImage))
#elseif canImport(UIKit)
            guard let uiImage = UIImage(data: data) else {
                throw TransferError.importFailed
            }
            return ProfileImage(image: Image(uiImage: uiImage))
#else
            throw TransferError.importFailed
#endif
        }
    }
    
    enum TransferError: Error {
        case importFailed
    }
}
