//
//  DetailViewModel.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/16/26.
//

import Foundation
import Combine

@MainActor
final class DetailViewModel {
    @Published private(set) var movie: Movie?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    private let movieId: Int
    private let movieRepositaryProtocol: MovieRepositoryProtocol
    
    var genreNames: [String] {
        guard let ids = movie?.genre_ids else { return [] }
        return GenreStore.shared.names(for: ids)
    }
    
    init(movieId: Int, movieRepositaryProtocol: MovieRepositoryProtocol? = nil) {
        self.movieId = movieId
        self.movieRepositaryProtocol = movieRepositaryProtocol ?? MovieRepository()
    }
    
    func loadMovie() {
        isLoading = true
        Task {
            do {
                self.movie = try await self.movieRepositaryProtocol.getMovieDetails(id: self.movieId)
                
            } catch let error as APIError {
                errorMessage = error.message()
            }
            self.isLoading = false
        }
    }
    
    func toggleFavorite() {
        guard let movie = movie else { return }
        
        Task {
            movieRepositaryProtocol.toggleFavorite(movieId: movie.id)
            self.movie = try await movieRepositaryProtocol.getMovieDetails(id: movie.id)
        }
    }
}

