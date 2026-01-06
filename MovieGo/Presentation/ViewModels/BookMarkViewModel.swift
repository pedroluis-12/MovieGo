import SwiftUI

class BookmarkListViewModel: ObservableObject {
    @Published var bookmarkedMovies: [Movie] = []
    
    private let bookmarkRepository: BookmarkRepository
    private let movieRepository: MovieRepository
    
    init(bookmarkRepository: BookmarkRepository = BookmarkRepository.shared, movieRepository: MovieRepository) {
        self.bookmarkRepository = bookmarkRepository
        self.movieRepository = movieRepository
        
        loadBookmarkedMoviesFromCoreData()
    }
    
    func loadBookmarkedMovies() {
        let bookmarkedIds = bookmarkRepository.getAllBookmarkedMovies()
        
        if bookmarkedIds.isEmpty {
            loadBookmarkedMoviesFromCoreData()
            return
        }
        
        for id in bookmarkedIds {
            movieRepository.getMovieDetail(movieId: id) { [weak self] result in
                switch result {
                case .success(let movieDetail):
                    DispatchQueue.main.async {
                        let movie = Movie(id: movieDetail.id, title: movieDetail.title, overview: movieDetail.overview, posterPath: movieDetail.posterPath)
                        self?.bookmarkedMovies.append(movie)
                        self?.bookmarkRepository.addBookmark(movie: movie) // Simpan ke Core Data jika baru
                    }
                case .failure(let error):
                    print("Failed to fetch movie details: \(error)")
                }
            }
        }
    }
    
    private func loadBookmarkedMoviesFromCoreData() {
        let movies = bookmarkRepository.loadBookmarksFromCoreData()
        DispatchQueue.main.async {
            self.bookmarkedMovies = movies // Update dari Core Data
        }
    }
}
