//
//  GetPopularMoviesUseCase.swift
//  tmdb
//
//  Created by Aulia Octaviani on 24/10/24.
//

// Domain/UseCases/GetPopularMoviesUseCase.swift

//import Foundation
//
//public class GetPopularMoviesUseCase {
//    private let repository: MovieRepository
//
//     init(repository: MovieRepository) {
//        self.repository = repository
//    }
//
//    public func execute(completion: @escaping (Result<[Movie], Error>) -> Void) {
//        repository.getPopularMovies(completion: completion)
//    }
//}

// Domain/UseCases/GetPopularMoviesUseCase.swift

import Foundation

public class GetPopularMoviesUseCase {
    private let repository: MovieRepository

    public init(repository: MovieRepository) {
        self.repository = repository
    }

    public func execute(completion: @escaping (Result<[Movie], Error>) -> Void) {
        repository.getPopularMovies { result in
            completion(result)
        }
    }
}


