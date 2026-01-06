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
    let movieService = MovieService()
    let movieRepository: MovieRepository
    let getPopularMoviesUseCase: GetPopularMoviesUseCase
    let searchMoviesUseCase: SearchMoviesUseCase
    let getMovieDetailUseCase: GetMovieDetailUseCase
    
    init() {
        movieRepository = MovieRepositoryImpl(service: movieService, persistentContainer: persistentContainer)
        
        getPopularMoviesUseCase = GetPopularMoviesUseCase(repository: movieRepository)
        searchMoviesUseCase = SearchMoviesUseCase(repository: movieRepository)
        getMovieDetailUseCase = GetMovieDetailUseCase(repository: movieRepository)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                getPopularMoviesUseCase: getPopularMoviesUseCase,
                searchMoviesUseCase: searchMoviesUseCase,
                getMovieDetailUseCase: getMovieDetailUseCase
            )
            .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
