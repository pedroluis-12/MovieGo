import Foundation
import CoreData

public class MovieMarkRepository {
    public static let shared = MovieMarkRepository()
    private var movieMarkedMovies = Set<Int>()
    private let persistentContainer: NSPersistentContainer
    
    private init(persistentContainer: NSPersistentContainer = NSPersistentContainer(name: "MovieGo2")) {
        self.persistentContainer = persistentContainer
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    public func isMovieMarked(movieId: Int) -> Bool {
        return movieMarkedMovies.contains(movieId)
    }
    
    public func addMovieMark(movie: Movie) {
        movieMarkedMovies.insert(movie.id)
        saveMovieToCoreData(movie: movie)
    }
    
    public func removeMovieMark(movieId: Int) {
        movieMarkedMovies.remove(movieId)
        deleteMovieFromCoreData(movieId: movieId)
    }
    
    public func getAllMovieMarkedMovies() -> [Int] {
        return Array(movieMarkedMovies)
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
    
    public func loadMovieMarksFromCoreData() -> [Movie] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            let movieEntities = try context.fetch(fetchRequest)
            return movieEntities.map { Movie(id: Int($0.id), title: $0.title ?? "", overview: $0.overview ?? "", posterPath: $0.posterPath)}
        } catch {
            print("Failed to fetch movies from Core Data: \(error)")
            return []
        }
    }
}
