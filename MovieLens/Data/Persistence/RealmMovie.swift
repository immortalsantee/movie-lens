//
//  RealmMovie.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

import RealmSwift

class RealmMovie: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var overview: String?
    @Persisted var releasedDate: String?
    @Persisted var posterPath: String?
    @Persisted var backdropPath: String?
    @Persisted var voteAverage: Double?
    @Persisted var popularity: Double?
    @Persisted var voteCount: Int?
    @Persisted var isFavorite: Bool = false
    @Persisted var searchQuery: String
    @Persisted var genreIds: List<Int>
}

extension RealmMovie {
    convenience init(movie: Movie, query: String) {
        self.init()
        
        id = movie.id
        title = movie.title
        overview = movie.overview
        releasedDate = movie.releaseDate
        posterPath = movie.posterPath
        backdropPath = movie.backdropPath
        voteAverage = movie.voteAverage
        popularity = movie.popularity
        voteCount = movie.voteCount
        searchQuery = query
        if let ids = movie.genreIds {
            genreIds.append(objectsIn: ids)
        }
    }
}

extension RealmMovie {
    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            releaseDate: releasedDate,
            posterPath: posterPath,
            backdropPath: backdropPath,
            voteAverage: voteAverage,
            popularity: popularity,
            voteCount: voteCount,
            isFavorite: isFavorite,
            genreIds: Array(genreIds)
        )
    }
}
