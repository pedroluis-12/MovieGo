//
//  MoviewDetailView.swift
//  tmdb
//
//  Created by Aulia Octaviani on 24/10/24.
//

//// Presentation/Views/MovieDetailView.swift

import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel
    
    init(viewModel: MovieDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Poster Image
                if let posterPath = viewModel.movieDetail?.posterPath,
                   let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .foregroundColor(.gray)
                }
                
                HStack(){
                    // Title
                    Text(viewModel.movieDetail?.title ?? "Unknown Title")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    // Tombol Bookmark
                    Button(action: {
                        viewModel.toggleBookmark()
                    }) {
                        Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(viewModel.isBookmarked ? .yellow : .gray)
                            .imageScale(.large)
                            .padding()
                    }
                    
                }
                
                
                // Overview
                Text(viewModel.movieDetail?.overview ?? "No overview available.")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
                // Tambahkan informasi tambahan jika ada
                // Contoh:
                // Text("Release Date: \(viewModel.movieDetail?.releaseDate ?? "N/A")")
                // Text("Rating: \(viewModel.movieDetail?.voteAverage ?? 0)/10")
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(viewModel.movieDetail?.title ?? "Detail")
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $viewModel.errorMessage) { errorMessage in
            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}
