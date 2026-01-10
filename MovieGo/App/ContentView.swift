// ContentView.swift

// ContentView.swift
// ContentView.swift

import SwiftUI

struct ContentView: View {
    let getPopularMoviesUseCase: GetPopularMoviesUseCase
    let searchMoviesUseCase: SearchMoviesUseCase
    let getMovieDetailUseCase: GetMovieDetailUseCase
    // let getMovieVideosUseCase: GetMovieVideosUseCase // Dihapus karena tidak digunakan
    
    var body: some View {
        MovieListView(
            viewModel: MovieListViewModel(
                getPopularMoviesUseCase: getPopularMoviesUseCase,
                searchMoviesUseCase: searchMoviesUseCase
            ),
            getMovieDetailUseCase: getMovieDetailUseCase
            // getMovieVideosUseCase: getMovieVideosUseCase // Dihapus karena tidak digunakan
        )
    }
}
