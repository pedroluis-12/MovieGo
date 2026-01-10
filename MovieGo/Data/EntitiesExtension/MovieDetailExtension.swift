//
//  MovieDetailExtension.swift
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

import Foundation

extension MovieDetail {
    public var isMovieMarked: Bool {
        MovieMarkRepository.shared.isMovieMarked(movieId: self.id)
    }
}
