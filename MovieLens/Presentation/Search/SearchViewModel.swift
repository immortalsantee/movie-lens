//
//  SearchViewModel.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

import Combine
import Foundation

final class SearchViewModel {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let movieRepository: MovieRepositoryProtocol
    private var currentPage = 1
    private var currentQuery = ""
    
    private var favoriteIds = Set<Int>()
    private var cancellables = Set<AnyCancellable>()

    init(repository: MovieRepositoryProtocol = MovieRepository()) {
        self.movieRepository = repository
    }

    func search(query: String) {
        currentQuery = query
        currentPage = 1
        loadMovies(reset: true)
    }

    func loadNextPage() {
        currentPage += 1
        loadMovies(reset: false)
    }

    private func loadMovies(reset: Bool) {
        isLoading = true
        
        Task {
            do {
                let result = try await movieRepository.searchMovies(query: currentQuery, page: currentPage)
                
                await MainActor.run {
                    if !result.isEmpty {
                        if reset {
                            movies = result
                            
                            let favs = result.compactMap { ($0.isFavorite == true) ? $0.id : nil }
                            favoriteIds = Set(favs)
                        } else {
                            movies.append(contentsOf: result)
                            
                            let moreFavs = result.compactMap { ($0.isFavorite == true) ? $0.id : nil }
                            favoriteIds.formUnion(moreFavs)
                        }
                    }
                    
                    isLoading = false
                }
            } catch (let error as APIError) {
                await MainActor.run {
                    errorMessage = error.message()
                    isLoading = false
                }
            }
        }
    }
    
    func clear() {
        movies = []
        favoriteIds.removeAll()
    }
    
    // MARK: - Favorite Updates
    func applyFavoriteChange(movieId: Int, isFavorite: Bool) {
        guard let index = movies.firstIndex(where: { $0.id == movieId }) else { return }

        var updated = movies[index]
        updated.isFavorite = isFavorite
        movies[index] = updated
    }
    
    func isFavorite(_ id: Int) -> Bool {
        favoriteIds.contains(id)
    }
}
