import Foundation

public class MovieMarkMovieUseCase {
    private let MovieMarkRepository: MovieMarkRepository
    
    public init(movieMarkRepository: MovieMarkRepository = .shared) {
        self.MovieMarkRepository = movieMarkRepository
    }
    
    public func execute(movie: Movie) {
        if MovieMarkRepository.isMovieMarked(movieId: movie.id) {
            MovieMarkRepository.removeMovieMark(movieId: movie.id)
        } else {
            MovieMarkRepository.addMovieMark(movie: movie)
        }
    }
    
    public func isMovieMarked(movieId: Int) -> Bool {
        return MovieMarkRepository.isMovieMarked(movieId: movieId)
    }
}
