//  MovieRepository.swift
//  MovieGo
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//
import Foundation

public protocol MovieRepository {
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void)
    func getMovieDetail(movieId: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void)
//    func getMovieVideos(movieId: Int, completion: @escaping (Result<[Video], Error>) -> Void)
    // Tambahkan metode lainnya sesuai kebutuhan
}


