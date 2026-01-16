//
//  MovieRepositoryProtocol.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

import Foundation

protocol MovieRepositoryProtocol {
    func searchMovies(query: String, page: Int) async throws -> [Movie]
    func getMovieDetails(id: Int) async throws -> Movie?
    func toggleFavorite(movieId: Int)
    func getFavorites() async -> [Movie]
}
