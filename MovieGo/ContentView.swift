//
//  ContentView.swift
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    let getPopularMoviesUseCase: GetPopularMoviesUseCase
    let searchMoviesUseCase: SearchMoviesUseCase
    let getMovieDetailUseCase: GetMovieDetailUseCase
    
    var body: some View {
        MovieListView(
            viewModel: MovieListViewModel(
                getPopularMoviesUseCase: getPopularMoviesUseCase,
                searchMoviesUseCase: searchMoviesUseCase
            ),
            getMovieDetailUseCase: getMovieDetailUseCase
        )
    }
}
