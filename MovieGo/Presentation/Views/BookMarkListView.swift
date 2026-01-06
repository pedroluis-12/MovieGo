import SwiftUI
import Kingfisher
import CoreData

struct BookmarkListView: View {
    @StateObject private var viewModel: BookmarkListViewModel

    init(movieRepository: MovieRepository = MovieRepositoryImpl(service: MovieService(), persistentContainer: NSPersistentContainer(name: "MovieGo2"))) {
        _viewModel = StateObject(wrappedValue: BookmarkListViewModel(movieRepository: movieRepository))
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.bookmarkedMovies) { movie in
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
            .navigationTitle("Bookmarks")
            .onAppear {
                viewModel.loadBookmarkedMovies()
            }
        }
    }
}
