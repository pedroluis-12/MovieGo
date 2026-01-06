//
//  MovieDetailExtension.swift
//  MovieGo
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

import Foundation

extension MovieDetail {
    public var isBookmarked: Bool {
        BookmarkRepository.shared.isBookmarked(movieId: self.id)
    }
}
