//
//  GetMovieDetailUserCase.swift
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

import Foundation

public class GetMovieDetailUseCase {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func execute(movieId: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        repository.getMovieDetail(movieId: movieId, completion: completion)
    }
}
