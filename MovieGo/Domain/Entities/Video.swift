//
//  Video.swift
//  tmdb
//
//  Created by Aulia Octaviani on 24/10/24.
//

// Data/API/Video.swift

import Foundation

public struct VideoResponse: Codable {
    public let results: [Video]
}

public struct Video: Codable, Identifiable {
    public let id: String
    public let key: String
    public let name: String
    public let site: String
    public let type: String
}
