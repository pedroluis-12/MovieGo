//
//  GetPopularMoviesUseCase.swift
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

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


