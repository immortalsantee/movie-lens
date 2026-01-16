//
//  MovieRepositary.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

import Foundation

final class MovieRepository: MovieRepositoryProtocol {

    private let network: NetworkServicing
    private let realmService = RealmService()

    init(network: NetworkServicing = NetworkService()) {
        self.network = network
    }
    
    func searchMovies(query: String, page: Int) async throws -> [Movie] {
        let isOnline = SMNetworkMonitor.shared.isConnected
        
        if !isOnline {
            let cachedRealm = realmService.getMovies(query: query, page: page)
            return cachedRealm.map { $0.toDomain() }
        }
        
        let movies = try await network.searchMovies(query: query, page: page)
        
        let realmMovies = movies.map { RealmMovie(movie: $0, query: query) }
        realmService.saveMovies(realmMovies)

        return realmMovies.map { $0.toDomain() }
    }

    func getMovieDetails(id: Int) async throws -> Movie? {
        if let cached = realmService.getMovie(id: id) {
            return cached.toDomain()
        }
        let movie = try await network.getMovieDetails(id: id)
        realmService.saveMovies([RealmMovie(movie: movie, query: "")])
        return movie
    }

    func toggleFavorite(movieId: Int) {
        realmService.toggleFavorite(movieId: movieId)
    }

    func getFavorites() async -> [Movie] {
        let favorites = realmService.getFavorites()
        return favorites.map { $0.toDomain() }
    }
}
