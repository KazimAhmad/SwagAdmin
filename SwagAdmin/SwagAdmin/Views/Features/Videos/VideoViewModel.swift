//
//  VideoViewModel.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 07/02/2026.
//
import LinkPresentation
import UniformTypeIdentifiers
import SwiftUI

class VideoViewModel: ObservableObject {
    @Published var image: Image?
    
    func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func loadImage(url: String) {
        guard let previewURL = URL(string: url) else { return }
        
        
        Task {
            let provider = LPMetadataProvider()
            let metadata = try await provider.startFetchingMetadata(for: previewURL)
            if let preiewImage = try await convertToImage(metadata.imageProvider) {
                image = Image(uiImage: preiewImage)
            }
        }
    }
    
    private func convertToImage(_ imageProvider: NSItemProvider?) async throws -> UIImage? {
        var image: UIImage?
        
        if let imageProvider {
            let type = String(describing: UTType.image)
            
            if imageProvider.hasItemConformingToTypeIdentifier(type) {
                let item = try await imageProvider.loadItem(forTypeIdentifier: type)
                
                if item is UIImage {
                    image = item as? UIImage
                }
                
                if item is URL {
                    guard let url = item as? URL,
                          let data = try? Data(contentsOf: url) else { return nil }
                    
                    image = UIImage(data: data)
                }
                
                if item is Data {
                    guard let data = item as? Data else { return nil }
                    
                    image = UIImage(data: data)
                }
            }
        }
        return image
    }
}
