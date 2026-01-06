/// Domain/UseCases/BookmarkMovieUseCase.swift
//
import Foundation

public class BookmarkMovieUseCase {
    private let bookmarkRepository: BookmarkRepository
    
    public init(bookmarkRepository: BookmarkRepository = .shared) {
        self.bookmarkRepository = bookmarkRepository
    }
    
    public func execute(movie: Movie) {
        if bookmarkRepository.isBookmarked(movieId: movie.id) {
            bookmarkRepository.removeBookmark(movieId: movie.id)
        } else {
            bookmarkRepository.addBookmark(movie: movie)
        }
    }
    
    // Menambahkan metode untuk mengecek status bookmark
    public func isBookmarked(movieId: Int) -> Bool {
        return bookmarkRepository.isBookmarked(movieId: movieId)
    }
}
