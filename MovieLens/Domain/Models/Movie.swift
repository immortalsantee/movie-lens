//
//  Movie.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

struct MovieSearchResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String?
    let releaseDate: String?
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double?
    let popularity: Double?
    let voteCount: Int?
    var isFavorite: Bool?
    let genreIds: [Int]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate   = "release_date"
        case posterPath    = "poster_path"
        case backdropPath  = "backdrop_path"
        case voteAverage   = "vote_average"
        case popularity
        case voteCount     = "vote_count"
        case isFavorite    = "is_favorite"
        case genreIds      = "genre_ids"
    }
}
