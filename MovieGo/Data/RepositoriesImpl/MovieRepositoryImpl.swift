//
//  MovieRepositoryImpl.swift
//  MovieGo
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

import Foundation
import CoreData

public class MovieRepositoryImpl: MovieRepository {
    private let service: MovieService
    private let persistentContainer: NSPersistentContainer
    
    public init(service: MovieService, persistentContainer: NSPersistentContainer) {
        self.service = service
        self.persistentContainer = persistentContainer
    }
    
    // MARK: - Get Popular Movies
    public func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        service.fetchPopularMovies { result in
            switch result {
            case .success(let movies):
                // menyimpan pada core-data
                self.saveMoviesToCoreData(movies: movies)
                // melajutkan untuk ditampilkan
                completion(.success(movies))
            case .failure(let error):
                // Jika gagal ambil dari API, coba ambil dari Core Data
                let movies = self.fetchMoviesFromCoreData()
                if !movies.isEmpty {
                    completion(.success(movies))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Search Movies
    public func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        service.searchMovies(query: query) { result in
            switch result {
            case .success(let movies):
                // Opsional: Simpan hasil pencarian ke Core Data jika diinginkan
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Get Movie Detail
    public func getMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        service.fetchMovieDetail(movieId: movieId) { result in
            switch result {
            case .success(let movieDetail):
                // Opsional: Simpan detail movie ke Core Data jika diinginkan
                completion(.success(movieDetail))
            case .failure(let error):
                // Jika gagal ambil dari API, coba ambil dari Core Data
                if let movieDetail = self.fetchMovieDetailFromCoreData(movieId: movieId) {
                    completion(.success(movieDetail))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Get Movie Videos
//    public func getMovieVideos(movieId: Int, completion: @escaping (Result<[Video], Error>) -> Void) {
//                tmdbService.fetchMovieVideos(movieId: movieId, completion: completion)
//            }
    
    // MARK: - Private Helper Methods
    
    private func saveMoviesToCoreData(movies: [Movie]) {
        let context = persistentContainer.viewContext
        // Hapus data lama
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MovieEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to delete existing movies: \(error)")
        }
        
        // Simpan data baru
        for movie in movies {
            let movieEntity = MovieEntity(context: context)
            movieEntity.id = Int64(movie.id)
            movieEntity.title = movie.title
            movieEntity.overview = movie.overview
            movieEntity.posterPath = movie.posterPath
            // Set properti lain sesuai entitas jika ada
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save movies: \(error)")
        }
    }
    
    private func fetchMoviesFromCoreData() -> [Movie] {
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
    
    
    private func fetchMovieDetailFromCoreData(movieId: Int) -> MovieDetail? {
            let context = persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", movieId)
            do {
                if let movieEntity = try context.fetch(fetchRequest).first {
                    // Konversi MovieEntity ke MovieDetail
//                    return movieEntity.toMovieDetail()
                }
            } catch {
                print("Failed to fetch movie detail from Core Data: \(error)")
            }
            return nil
        }
}


