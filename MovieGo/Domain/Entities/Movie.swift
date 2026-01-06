//
//  Movie.swift
//  tmdb
//
//  Created by Aulia Octaviani on 24/10/24.
//

// Domain/Entities/Movie.swift
import Foundation

public struct Movie: Identifiable, Codable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String?
    
    public init(id: Int, title: String, overview: String, posterPath: String?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
    }
}
