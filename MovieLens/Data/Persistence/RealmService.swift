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
        var config = Realm.Configuration(schemaVersion: 1)
        
        if SMAppEnvironment.isUITest {
            config.fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("UITest.realm")
            config.deleteRealmIfMigrationNeeded = true
        }
        
        config.schemaVersion = 1
        config.migrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: RealmMovie.className()) { _, newObject in
                    newObject?["backdropPath"] = nil
                    newObject?["voteAverage"] = 0.0
                    newObject?["voteCount"] = 0
                }
            }

            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: RealmMovie.className()) { _, newObject in
                    newObject?["genreIds"] = List<Int>()
                }
            }
        }
        
        do {
            realm = try Realm(configuration: config)
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    
    /// Just for finding database location.
    private func printRealmLocation() {
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL
        print("Realm file location:", realmURL?.path ?? "No path found")
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
                SMFavoriteNotificationKey.movieId: movieId,
                SMFavoriteNotificationKey.isFavorite: newValue
            ]
        )
    }

    func getFavorites() -> [RealmMovie] {
        Array(realm.objects(RealmMovie.self).filter("isFavorite == true"))
    }
}
