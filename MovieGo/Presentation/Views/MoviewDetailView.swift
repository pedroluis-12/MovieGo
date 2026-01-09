//
//  MoviewDetailView.swift
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

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
                    
                    // Tombol Moviemark
                    Button(action: {
                        viewModel.togglemovieMark()
                    }) {
                        Image(systemName: viewModel.isMoviemarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(viewModel.isMoviemarked ? .yellow : .gray)
                            .imageScale(.large)
                            .padding()
                    }
                    
                }
                
                
                // Overview
                Text(viewModel.movieDetail?.overview ?? "No overview available.")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                
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
