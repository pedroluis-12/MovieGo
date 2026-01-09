//
//  MovieDetailViewModel.swift
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

import Foundation
import Combine

public class MovieDetailViewModel: ObservableObject {
    @Published public var movieDetail: MovieDetail?
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    @Published public var isMoviemarked: Bool = false
    
    private let getMovieDetailUseCase: GetMovieDetailUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private let movieMarkMovieUseCase: MovieMarkMovieUseCase
    public init(getMovieDetailUseCase: GetMovieDetailUseCase, movieMarkMovieUseCase: MovieMarkMovieUseCase = MovieMarkMovieUseCase(), movieId: Int) {
        self.getMovieDetailUseCase = getMovieDetailUseCase
        self.movieMarkMovieUseCase = movieMarkMovieUseCase
        
        fetchMovieDetail(movieId: movieId)
        
        self.isMoviemarked = movieMarkMovieUseCase.isMovieMarked(movieId: movieId)
    }

    public func togglemovieMark() {
        guard let movieDetail = movieDetail else { return }
        
        let movie = Movie(id: movieDetail.id, title: movieDetail.title, overview: movieDetail.overview, posterPath: movieDetail.posterPath)
        
        movieMarkMovieUseCase.execute(movie: movie)
        isMoviemarked.toggle()
    }

    public func fetchMovieDetail(movieId: Int) {
        isLoading = true
        errorMessage = nil

        getMovieDetailUseCase.execute(movieId: movieId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let movieDetail):
                    self?.movieDetail = movieDetail
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .invalidURL:
                self.errorMessage = "URL Inválida"
            case .noData:
                self.errorMessage = "Sem dados"
            case .decodingError:
                self.errorMessage = "Erro de decodificação"
            case .unknown:
                self.errorMessage = "Outro Erro"
            }
        } else {
            self.errorMessage = error.localizedDescription
        }
    }
}



