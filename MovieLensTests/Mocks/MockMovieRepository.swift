//
//  MockMovieRepository.swift
//  MovieLensTests
//
//  Created by Santosh Maharjan on 1/17/26.
//

import Foundation
@testable import MovieLens

final class MockMovieRepository: MovieRepositoryProtocol {

    var searchResult: [Movie] = []
    var favoritesResult: [Movie] = []
    var shouldThrowError = false

    func searchMovies(query: String, page: Int) async throws -> [Movie] {
        if shouldThrowError { throw APIError.invalidURL }
        return searchResult
    }

    func getMovieDetails(id: Int) async throws -> Movie? {
        if shouldThrowError { throw APIError.invalidURL }
        return searchResult.first { $0.id == id }
    }

    func toggleFavorite(movieId: Int) {
        if let index = searchResult.firstIndex(where: { $0.id == movieId }) {
            var m = searchResult[index]
            m.isFavorite = !(m.isFavorite ?? false)
            searchResult[index] = m
        }
    }

    func getFavorites() async -> [Movie] {
        if shouldThrowError { return [] }
        return favoritesResult
    }
}
