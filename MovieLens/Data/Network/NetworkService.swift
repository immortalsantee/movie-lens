//
//  NetworkService.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

import Foundation

protocol NetworkServicing {
    func searchMovies(query: String, page: Int) async throws -> [Movie]
    func getMovieDetails(id: Int) async throws -> Movie
    func getGenres() async throws -> [Genre]
}

final class NetworkService: NetworkServicing {
    
    private func fetch<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard http.statusCode == 200 else {
            throw APIError.from(statusCode: http.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }


    func searchMovies(query: String, page: Int) async throws -> [Movie] {
        guard let url = URL(string: Endpoint.searchMovies(query: query, page: page).urlString) else {
            throw APIError.invalidURL
        }

        let response: MovieSearchResponse = try await fetch(url)
        return response.results
    }

    func getMovieDetails(id: Int) async throws -> Movie {
        guard let url = URL(string: Endpoint.movieDetails(id: id).urlString) else {
            throw APIError.invalidURL
        }
        
        let response: Movie = try await fetch(url)
        return response
    }
    
    func getGenres() async throws -> [Genre] {
        guard let url = URL(string: Endpoint.genres.urlString) else {
            throw APIError.invalidURL
        }

        let response: GenreResponse = try await fetch(url)
        return response.genres
    }
}
