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
        releasedDate = movie.release_date
        posterPath = movie.poster_path
        backdropPath = movie.backdrop_path
        voteAverage = movie.vote_average
        popularity = movie.popularity
        voteCount = movie.vote_count
        searchQuery = query
        if let ids = movie.genre_ids {
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
            release_date: releasedDate,
            poster_path: posterPath,
            backdrop_path: backdropPath,
            vote_average: voteAverage,
            popularity: popularity,
            vote_count: voteCount,
            is_favorite: isFavorite,
            genre_ids: Array(genreIds)
        )
    }
}
