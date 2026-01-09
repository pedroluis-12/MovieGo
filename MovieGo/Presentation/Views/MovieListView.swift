//
//  MovieListView.swift
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

import SwiftUI
import Kingfisher

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
                    ProgressView("Carregando...")
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
            .navigationTitle("Filmes Populares")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MovieMarkListView()){
                        Image(systemName: "bookmark.fill")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
            }
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(title: Text("Erro"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    @ViewBuilder
    private func createDetailView(for movie: Movie) -> some View {
        let detailViewModel = MovieDetailViewModel(
            getMovieDetailUseCase: getMovieDetailUseCase,
            movieId: movie.id
        )
        MovieDetailView(viewModel: detailViewModel)
    }
}






