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
    let release_date: String?
    let poster_path: String?
    let backdrop_path: String?
    let vote_average: Double?
    let popularity: Double?
    let vote_count: Int?
    let is_favorite: Bool?
    let genre_ids: [Int]?
}


