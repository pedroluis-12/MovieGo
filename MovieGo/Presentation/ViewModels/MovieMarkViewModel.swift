import SwiftUI

class MovieMarkListViewModel: ObservableObject {
    @Published var movieMarkedMovies: [Movie] = []
    
    private let movieMarkRepository: MovieMarkRepository
    private let movieRepository: MovieRepository
    
    init(movieMarkRepository: MovieMarkRepository = MovieMarkRepository.shared, movieRepository: MovieRepository) {
        self.movieMarkRepository = movieMarkRepository
        self.movieRepository = movieRepository
        
        loadmovieMarkedMoviesFromCoreData()
    }
    
    func loadmovieMarkedMovies() {
        let movieMarkedIds = movieMarkRepository.getAllMovieMarkedMovies()
        
        if movieMarkedIds.isEmpty {
            loadmovieMarkedMoviesFromCoreData()
            return
        }
        
        for id in movieMarkedIds {
            movieRepository.getMovieDetail(movieId: id) { [weak self] result in
                switch result {
                case .success(let movieDetail):
                    DispatchQueue.main.async {
                        let movie = Movie(id: movieDetail.id, title: movieDetail.title, overview: movieDetail.overview, posterPath: movieDetail.posterPath)
                        self?.movieMarkedMovies.append(movie)
                        self?.movieMarkRepository.addMovieMark(movie: movie)
                    }
                case .failure(let error):
                    print("Failed to fetch movie details: \(error)")
                }
            }
        }
    }
    
    private func loadmovieMarkedMoviesFromCoreData() {
        let movies = movieMarkRepository.loadMovieMarksFromCoreData()
        DispatchQueue.main.async {
            self.movieMarkedMovies = movies
        }
    }
}
