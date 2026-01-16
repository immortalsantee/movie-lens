//
//  Genre.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/16/26.
//

struct GenreResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
