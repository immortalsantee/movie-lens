//
//  RealmService.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

import RealmSwift
internal import Realm

final class RealmService {

    private let realm: Realm
    
    init() {
        let config = RealmService.makeConfiguration()
        Realm.Configuration.defaultConfiguration = config
        self.realm = try! Realm()
    }
    
    /// Just for finding database location.
    private func printRealmLocation() {
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL
        print("Realm file location:", realmURL?.path ?? "No path found")
    }

    private static func makeConfiguration() -> Realm.Configuration {
        Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: { migration, oldSchemaVersion in

                if oldSchemaVersion < 2 {
                    migration.enumerateObjects(ofType: RealmMovie.className()) { _, newObject in
                        newObject?["backdropPath"] = nil
                        newObject?["voteAverage"] = 0.0
                        newObject?["voteCount"] = 0
                    }
                }

                if oldSchemaVersion < 4 {
                    migration.enumerateObjects(ofType: RealmMovie.className()) { _, newObject in
                        newObject?["genreIds"] = List<Int>()
                    }
                }
            }
        )
    }

    func saveMovies(_ movies: [RealmMovie]) {
        try? realm.write {
            for movie in movies {
                if let existing = realm.object(ofType: RealmMovie.self, forPrimaryKey: movie.id) {
                    movie.isFavorite = existing.isFavorite
                }
                realm.add(movie, update: .modified)
            }
        }
    }
    
    func getMovies(query: String, page: Int, pageSize: Int = 20) -> [RealmMovie] {
        let startIndex = (page - 1) * pageSize
        
        let results = realm.objects(RealmMovie.self)
            .filter("title CONTAINS[c] %@", query)
            .sorted(byKeyPath: "popularity")
        
        let pageResults = results.dropFirst(startIndex).prefix(pageSize)
        
        return Array(pageResults)
    }
    
    func getMovie(id: Int) -> RealmMovie? {
        realm.objects(RealmMovie.self).filter("id == %@", id).first
    }

    func toggleFavorite(movieId: Int) {
        guard let movie = realm.object(ofType: RealmMovie.self, forPrimaryKey: movieId) else { return }
        var newValue = false
        
        try? realm.write {
            movie.isFavorite.toggle()
            newValue = movie.isFavorite
            realm.add(movie, update: .modified)
        }
        
        // To make each cell responsive when favorite is toggled.
        NotificationCenter.default.post(
            name: .smFavoriteToggled,
            object: nil,
            userInfo: [
                FavoriteNotificationKey.movieId: movieId,
                FavoriteNotificationKey.isFavorite: newValue
            ]
        )
    }

    func getFavorites() -> [RealmMovie] {
        Array(realm.objects(RealmMovie.self).filter("isFavorite == true"))
    }
}
