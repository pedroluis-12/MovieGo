//
//  MovieListView.swift
//  tmdb
//
//  Created by Aulia Octaviani on 24/10/24.
//

// Presentation/ViewModels/MovieListViewModel.swift

import Foundation
import Combine

public class MovieListViewModel: ObservableObject {
    @Published public var movies: [Movie] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    @Published public var searchText: String = ""
    
    private let getPopularMoviesUseCase: GetPopularMoviesUseCase
    private let searchMoviesUseCase: SearchMoviesUseCase
    private var cancellables = Set<AnyCancellable>()

    public init(getPopularMoviesUseCase: GetPopularMoviesUseCase, searchMoviesUseCase: SearchMoviesUseCase) {
        self.getPopularMoviesUseCase = getPopularMoviesUseCase
        self.searchMoviesUseCase = searchMoviesUseCase
        setupBindings()
        fetchMovies()
    }

    private func setupBindings() {
        // Observe perubahan pada searchText dengan debounce untuk menghindari panggilan API berlebihan
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if query.isEmpty {
                    self.fetchMovies()
                } else {
                    self.searchMovies(query: query)
                }
            }
            .store(in: &cancellables)
    }

    public func fetchMovies() {
        isLoading = true
        errorMessage = nil
        getPopularMoviesUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let movies):
                    self?.movies = movies
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }

    public func searchMovies(query: String) {
        isLoading = true
        errorMessage = nil
        searchMoviesUseCase.execute(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let movies):
                    self?.movies = movies
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
                self.errorMessage = "URL tidak valid."
            case .noData:
                self.errorMessage = "Tidak ada data yang diterima."
            case .decodingError:
                self.errorMessage = "Gagal menguraikan data."
            case .unknown:
                self.errorMessage = "Terjadi kesalahan yang tidak diketahui."
            }
        } else {
            self.errorMessage = error.localizedDescription
        }
    }
}

// Tambahkan ekstensi ini untuk mengonversi String menjadi Identifiable
extension String: Identifiable {
    public var id: String { self }
}




