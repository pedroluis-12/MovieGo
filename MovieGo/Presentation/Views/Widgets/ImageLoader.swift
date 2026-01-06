//
//  ImageLoader.swift
//  tmdb
//
//  Created by Aulia Octaviani on 25/10/24.
//

// Presentation/Views/ImageLoader.swift

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private var cancellable: AnyCancellable?
    private let url: URL
    private let cache: ImageCache
    
    init(url: URL, cache: ImageCache = .shared) {
        self.url = url
        self.cache = cache
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        // Cek cache terlebih dahulu
        if let cachedImage = cache.getImage(for: url) {
            self.image = cachedImage
            return
        }
        
        // Unduh gambar dari jaringan
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] image in
                guard let self = self, let image = image else { return }
                self.cache.saveImage(image, for: self.url)
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
