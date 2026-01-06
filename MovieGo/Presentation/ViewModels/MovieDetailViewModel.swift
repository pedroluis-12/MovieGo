//
//  MovieDetailViewModel.swift
//  tmdb
//
//  Created by Aulia Octaviani on 24/10/24.
//

// Presentation/ViewModels/MovieDetailViewModel.swift

import Foundation
import Combine

public class MovieDetailViewModel: ObservableObject {
    // @Published public var movieDetail: MovieDetail?: Properti yang menyimpan detail film, yang diambil melalui use case. Setiap kali nilainya berubah, UI akan diperbarui.
    @Published public var movieDetail: MovieDetail?
    // @Published public var isLoading = false: Properti yang menunjukkan apakah data sedang dimuat. Ketika isLoading bernilai true, UI dapat menampilkan indikator pemuatan.
    @Published public var isLoading = false
    // @Published public var errorMessage: String?: Properti untuk menyimpan pesan kesalahan. Ketika kesalahan terjadi, properti ini akan diperbarui, dan UI dapat menampilkan pesan kesalahan kepada pengguna.
    @Published public var errorMessage: String?
    
    @Published public var isBookmarked: Bool = false
    
    
    // getMovieDetailUseCase adalah properti yang menampung instance dari GetMovieDetailUseCase. Ini diinisialisasi melalui konstruktor dan digunakan untuk mengambil detail film dari data repository.
    private let getMovieDetailUseCase: GetMovieDetailUseCase
    // cancellables adalah kumpulan (Set) dari objek AnyCancellable, yang diperlukan untuk mengelola siklus hidup data subscription ketika menggunakan Combine. Ini membantu mengelola memori dengan memastikan subscription dibatalkan ketika tidak lagi dibutuhkan.
    private var cancellables = Set<AnyCancellable>()
    
    private let bookmarkMovieUseCase: BookmarkMovieUseCase
    
    //    public init(getMovieDetailUseCase: GetMovieDetailUseCase, movieId: Int) {
    //        self.getMovieDetailUseCase = getMovieDetailUseCase
    //        // Saat MovieDetailViewModel dibuat, inisialisator langsung memanggil fungsi fetchMovieDetail, sehingga detail film dapat segera diambil dan ditampilkan oleh View.
    //        fetchMovieDetail(movieId: movieId)
    //    }
    public init(getMovieDetailUseCase: GetMovieDetailUseCase, bookmarkMovieUseCase: BookmarkMovieUseCase = BookmarkMovieUseCase(), movieId: Int) {
        self.getMovieDetailUseCase = getMovieDetailUseCase
        self.bookmarkMovieUseCase = bookmarkMovieUseCase
        
        fetchMovieDetail(movieId: movieId)
        
        // Panggil metode publik isBookmarked dari bookmarkMovieUseCase
        self.isBookmarked = bookmarkMovieUseCase.isBookmarked(movieId: movieId)
    }

    
    
//    public func toggleBookmark() {
//        guard let movie = movieDetail else { return }
//        bookmarkMovieUseCase.execute(movie: movie)
//        isBookmarked.toggle()
//    }
    public func toggleBookmark() {
        guard let movieDetail = movieDetail else { return }
        
        // Konversi dari MovieDetail ke Movie
        let movie = Movie(id: movieDetail.id, title: movieDetail.title, overview: movieDetail.overview, posterPath: movieDetail.posterPath)
        
        bookmarkMovieUseCase.execute(movie: movie)
        isBookmarked.toggle()
    }

    
    
    // Fungsi fetchMovieDetail bertanggung jawab untuk mengambil data detail film berdasarkan ID.
    public func fetchMovieDetail(movieId: Int) {
        // isLoading diatur ke true untuk menunjukkan bahwa data sedang dimuat, dan errorMessage diatur ke nil untuk menghapus pesan kesalahan lama.
        isLoading = true
        errorMessage = nil
        // Memanggil execute pada getMovieDetailUseCase dengan movieId. Callback closure ini menangani hasil yang dikembalikan (Result), yang berisi detail film (jika sukses) atau kesalahan (jika gagal).
        getMovieDetailUseCase.execute(movieId: movieId) { [weak self] result in
            DispatchQueue.main.async {
                // Menggunakan [weak self] untuk menghindari strong reference cycle.
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
    
    // handleError menangani kesalahan yang terjadi ketika mengambil detail film.
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



