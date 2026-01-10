//
//  MovieResponse.swift
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

import Foundation

public struct MovieResponse: Codable {
    public let results: [Movie]
    
    public init(results: [Movie]) {
        self.results = results
    }
}
