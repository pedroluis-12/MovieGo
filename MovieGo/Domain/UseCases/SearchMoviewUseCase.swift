//
//  SearchMoviewUseCase.swift
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.

import Foundation

public class SearchMoviesUseCase {
    private let repository: MovieRepository

    public init(repository: MovieRepository) {
        self.repository = repository
    }

    public func execute(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        repository.searchMovies(query: query) { result in
            completion(result)
        }
    }
}



