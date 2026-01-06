// Domain/Repositories/BookmarkRepository.swift

import Foundation
import CoreData

public class BookmarkRepository {
    public static let shared = BookmarkRepository()
    private var bookmarkedMovies = Set<Int>()
    private let persistentContainer: NSPersistentContainer
    
    private init(persistentContainer: NSPersistentContainer = NSPersistentContainer(name: "YourCoreDataModel")) {
        self.persistentContainer = persistentContainer
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    public func isBookmarked(movieId: Int) -> Bool {
        return bookmarkedMovies.contains(movieId)
    }
    
    public func addBookmark(movie: Movie) {
        bookmarkedMovies.insert(movie.id)
        saveMovieToCoreData(movie: movie)
    }
    
    public func removeBookmark(movieId: Int) {
        bookmarkedMovies.remove(movieId)
        deleteMovieFromCoreData(movieId: movieId)
    }
    
    public func getAllBookmarkedMovies() -> [Int] {
        return Array(bookmarkedMovies)
    }
    
    private func saveMovieToCoreData(movie: Movie) {
        let context = persistentContainer.viewContext
        let movieEntity = MovieEntity(context: context)
        movieEntity.id = Int64(movie.id)
        movieEntity.title = movie.title
        movieEntity.overview = movie.overview
        movieEntity.posterPath = movie.posterPath
        do {
            try context.save()
        } catch {
            print("Failed to save movie to Core Data: \(error)")
        }
    }
    
    private func deleteMovieFromCoreData(movieId: Int) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
        
        do {
            let movies = try context.fetch(fetchRequest)
            for movie in movies {
                context.delete(movie)
            }
            try context.save()
        } catch {
            print("Failed to delete movie from Core Data: \(error)")
        }
    }
    
    public func loadBookmarksFromCoreData() -> [Movie] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            let movieEntities = try context.fetch(fetchRequest)
            return movieEntities.map { $0.toDomain() }
        } catch {
            print("Failed to fetch movies from Core Data: \(error)")
            return []
        }
    }
}
