import SwiftUI
import Kingfisher
import CoreData

struct MovieMarkListView: View {
    @StateObject private var viewModel: MovieMarkListViewModel

    init(movieRepository: MovieRepository = MovieRepositoryImpl(service: MovieService(), persistentContainer: NSPersistentContainer(name: "MovieGo2"))) {
        _viewModel = StateObject(wrappedValue: MovieMarkListViewModel(movieRepository: movieRepository))
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.movieMarkedMovies) { movie in
                HStack {
                    if let posterPath = movie.posterPath,
                       let url = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)") {
                        KFImage(url)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 75)
                            .cornerRadius(4)
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 75)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(movie.title)
                            .font(.headline)
                        Text(movie.overview)
                            .font(.subheadline)
                            .lineLimit(2)
                    }
                }
            }
            .navigationTitle("Filmes Favoritos")
            .onAppear {
                viewModel.loadmovieMarkedMovies()
            }
        }
    }
}
