//
//  MovieListView.swift
//  tmdb
//
//  Created by Aulia Octaviani on 24/10/24.
//

// Presentation/Views/MovieListView.swift

import SwiftUI
import Kingfisher


// Presentation/Views/MovieListView.swift

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel
    let getMovieDetailUseCase: GetMovieDetailUseCase
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                
                // Movie List
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else {
                    List(viewModel.movies) { movie in
                        NavigationLink(destination: createDetailView(for: movie)) {
                            HStack(alignment: .top) {
                                if let posterPath = movie.posterPath,
                                   let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
                                    KFImage(url)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 75)
                                        .cornerRadius(4)
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 75)
                                        .foregroundColor(.gray)
                                }
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(movie.title)
                                        .font(.headline)
                                    Text(movie.overview)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(3)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Popular Movies")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: BookmarkListView()){
//                    NavigationLink(destination: BookmarkListView(viewModel: BookmarkListViewModel(getMovieDetailUseCase: getMovieDetailUseCase))) {
                        Image(systemName: "bookmark.fill")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
            }
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // Fungsi untuk membuat Detail View dengan ViewModel yang diperlukan
    @ViewBuilder
    private func createDetailView(for movie: Movie) -> some View {
        let detailViewModel = MovieDetailViewModel(
            getMovieDetailUseCase: getMovieDetailUseCase,
            movieId: movie.id
        )
        MovieDetailView(viewModel: detailViewModel)
    }
}






