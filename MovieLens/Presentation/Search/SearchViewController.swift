//
//  SearchViewController.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var movieSearchBar: UISearchBar?
    @IBOutlet weak var movieTableView: UITableView!
    
    //MARK: - Properties
    let searchViewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindSearchViewModel()
        bindFavoriteSync()
    }
    
    //MARK: - Setup
    private func setupUI() {
        title = "MovieLens"
        
        movieSearchBar?.delegate = self
        movieSearchBar?.placeholder = "Search any movies"
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.prefetchDataSource = self
        movieTableView.smRegisterCell(MovieTableViewCell.self)
        movieTableView.tableFooterView = UIView()
    }
    
    private func bindSearchViewModel() {
        searchViewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.movieTableView.reloadData()
            }
            .store(in: &cancellables)
        
        searchViewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showError(message)
            }
            .store(in: &cancellables)
        
        searchViewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                
            }
            .store(in: &cancellables)
    }
    
    private func bindFavoriteSync() {
        NotificationCenter.default.publisher(for: .smFavoriteToggled)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notif in
                guard
                    let self,
                    let userInfo = notif.userInfo,
                    let movieId = userInfo[SMFavoriteNotificationKey.movieId] as? Int,
                    let isFavorite = userInfo[SMFavoriteNotificationKey.isFavorite] as? Bool
                else { return }

                searchViewModel.applyFavoriteChange(movieId: movieId, isFavorite: isFavorite)
            }
            .store(in: &cancellables)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchViewModel.clear()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchViewModel.search(query: query)
        
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieTableViewCell = tableView.smDequeueReusableCell(forIndexPath: indexPath)
        
        let movie = searchViewModel.movies[indexPath.row]
        cell.configure(movie: movie)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = searchViewModel.movies[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVM = DetailViewModel(movieId: movie.id)
        let detailVC = DetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map({ $0.row }).max() else { return }
        
        if maxRow > searchViewModel.movies.count - 5 {
            searchViewModel.loadNextPage()
        }
    }
    
}
