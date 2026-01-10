//
//  NetworkError.swift
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case unknown
}
