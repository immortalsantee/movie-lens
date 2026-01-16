//
//  GenreStore.swift.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/16/26.
//

import Foundation

final class GenreStore {

    static let shared = GenreStore()
    private init() {}

    private var genres: [Int: String] = [:]
    private let queue = DispatchQueue(label: "genre.store.queue")

    func save(_ list: [Genre]) {
        queue.async {
            self.genres = Dictionary(uniqueKeysWithValues: list.map { ($0.id, $0.name) })
        }
    }

    func names(for ids: [Int]) -> [String] {
        queue.sync {
            ids.compactMap { genres[$0] }
        }
    }
}
