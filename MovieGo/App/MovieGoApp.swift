//
//  MovieGoApp.swift
//  MovieGo
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

import SwiftUI

@main
struct MovieGoApp: App {
    let persistentContainer = CoreDataStack.shared.persistentContainer
    let tmdbService = MovieService()
    let movieRepository: MovieRepository
    let getPopularMoviesUseCase: GetPopularMoviesUseCase
    let searchMoviesUseCase: SearchMoviesUseCase
    let getMovieDetailUseCase: GetMovieDetailUseCase
    // let getMovieVideosUseCase: GetMovieVideosUseCase // Dihapus karena tidak digunakan
    
    init() {
        // Inisialisasi Repository dengan semua parameter yang diperlukan
        movieRepository = MovieRepositoryImpl(service: tmdbService, persistentContainer: persistentContainer)
        
        // Inisialisasi Use Cases
        getPopularMoviesUseCase = GetPopularMoviesUseCase(repository: movieRepository)
        searchMoviesUseCase = SearchMoviesUseCase(repository: movieRepository)
        getMovieDetailUseCase = GetMovieDetailUseCase(repository: movieRepository)
        // getMovieVideosUseCase = GetMovieVideosUseCase(repository: movieRepository) // Dihapus karena tidak digunakan
    }
    
    var body: some Scene {
        WindowGroup {
            // Pass semua Use Cases ke ContentView
            ContentView(
                getPopularMoviesUseCase: getPopularMoviesUseCase,
                searchMoviesUseCase: searchMoviesUseCase,
                getMovieDetailUseCase: getMovieDetailUseCase
                // getMovieVideosUseCase: getMovieVideosUseCase // Dihapus karena tidak digunakan
            )
            .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
