//
//  FavoriteViewController.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/17/26.
//

import UIKit
import Combine

class FavoriteViewController: SearchViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        loadFavorites()
    }

    private func initialSetup() {
        title = "Favorites"
        movieSearchBar?.isHidden = true
    }
    
    private func loadFavorites() {
        Task {
            await searchViewModel.getFavoriteMovies()
        }
    }
}
