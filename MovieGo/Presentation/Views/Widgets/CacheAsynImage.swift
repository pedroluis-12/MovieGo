//
//  CacheAsynImage.swift
//  tmdb
//
//  Created by Aulia Octaviani on 25/10/24.
//

// Presentation/Views/CachedAsyncImage.swift

import SwiftUI

struct CachedAsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (UIImage) -> Image
    
    init(url: URL?,
         @ViewBuilder placeholder: () -> Placeholder,
         @ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url ?? URL(string: "https://example.com")!))
        self.placeholder = placeholder()
        self.image = image
    }
    
    var body: some View {
        content
            .onAppear {
                loader.load()
            }
            .onDisappear {
                loader.cancel()
            }
    }
    
    private var content: some View {
        Group {
            if let uiImage = loader.image {
                image(uiImage)
                    .resizable()
            } else {
                placeholder
            }
        }
    }
}
