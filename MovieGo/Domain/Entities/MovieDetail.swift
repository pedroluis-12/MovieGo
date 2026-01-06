//
//  MovieDetail.swift
//  tmdb
//
//  Created by Aulia Octaviani on 24/10/24.
//

// Domain/Entities/MovieDetail.swift
import Foundation

public struct MovieDetail: Codable, Identifiable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String?
    public let releaseDate: String
    public let runtime: Int?
    public let genres: [Genre]
    public let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime, genres
        case voteAverage = "vote_average"
    }
}

public struct Genre: Codable, Identifiable {
    public let id: Int
    public let name: String
}


