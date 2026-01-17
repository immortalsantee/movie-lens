//
//  Notification+Favorite.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/17/26.
//

import Foundation

extension Notification.Name {
    static let smFavoriteToggled = Notification.Name("sm.favorite.toggled")
}

enum FavoriteNotificationKey {
    static let movieId = "movieId"
    static let isFavorite = "isFavorite"
}
