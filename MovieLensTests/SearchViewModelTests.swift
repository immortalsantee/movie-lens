//
//  SearchViewModelTests.swift
//  MovieLensTests
//
//  Created by Santosh Maharjan on 1/17/26.
//

import XCTest
@testable import MovieLens

@MainActor
final class SearchViewModelTests: XCTestCase {

    private var viewModel: SearchViewModel!
    private var repository: MockMovieRepository!

    override func setUp() {
        super.setUp()
        repository = MockMovieRepository()
        viewModel = SearchViewModel(repository: repository)
    }

    override func tearDown() {
        viewModel = nil
        repository = nil
        super.tearDown()
    }

    func testSearchUpdatesMovies() async {
        repository.searchResult = [
            Movie(
                id: 1,
                title: "Test Movie",
                overview: "Overview",
                releaseDate: "2024",
                posterPath: nil,
                backdropPath: nil,
                voteAverage: 8.5,
                popularity: 100,
                voteCount: 10,
                isFavorite: false,
                genreIds: [1, 2]
            )
        ]
        
        viewModel.search(query: "Test")
        try? await Task.sleep(nanoseconds: 300_000_000)
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.title, "Test Movie")
    }

    func testApplyFavoriteChangeUpdatesMovie() {
        viewModel._setMoviesForTesting([
            Movie(
                id: 10,
                title: "Fav Movie",
                overview: nil,
                releaseDate: nil,
                posterPath: nil,
                backdropPath: nil,
                voteAverage: nil,
                popularity: nil,
                voteCount: nil,
                isFavorite: false,
                genreIds: nil
            )
        ])
        
        viewModel.applyFavoriteChange(movieId: 10, isFavorite: true)
        
        XCTAssertTrue(viewModel.movies.first?.isFavorite ?? false)
    }

    func testClearResetsMovies() {
        viewModel._setMoviesForTesting([
            Movie(
                id: 10,
                title: "Fav Movie",
                overview: nil,
                releaseDate: nil,
                posterPath: nil,
                backdropPath: nil,
                voteAverage: nil,
                popularity: nil,
                voteCount: nil,
                isFavorite: false,
                genreIds: nil
            )
        ])
        
        viewModel.clear()
        
        XCTAssertTrue(viewModel.movies.isEmpty)
    }
    
    func testLoadNextPageAppendsMovies() async {
        repository.searchResult = [
            Movie(
                id: 1,
                title: "Movie 1",
                overview: nil,
                releaseDate: nil,
                posterPath: nil,
                backdropPath: nil,
                voteAverage: nil,
                popularity: nil,
                voteCount: nil,
                isFavorite: false,
                genreIds: nil
            )
        ]
        
        viewModel.search(query: "Test")
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        repository.searchResult = [
            Movie(
                id: 2,
                title: "Movie 2",
                overview: nil,
                releaseDate: nil,
                posterPath: nil,
                backdropPath: nil,
                voteAverage: nil,
                popularity: nil,
                voteCount: nil,
                isFavorite: false,
                genreIds: nil
            )
        ]
        
        viewModel.loadNextPage()
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertEqual(viewModel.movies.count, 2)
        XCTAssertEqual(viewModel.movies[1].title, "Movie 2")
    }
    
    
    func testApplyFavoriteChangeUpdatesCorrectMovie() {
        viewModel._setMoviesForTesting([
            Movie(
                id: 1,
                title: "Movie 1",
                overview: nil,
                releaseDate: nil,
                posterPath: nil,
                backdropPath: nil,
                voteAverage: nil,
                popularity: nil,
                voteCount: nil,
                isFavorite: false,
                genreIds: nil
            ),
            Movie(
                id: 2,
                title: "Movie 2",
                overview: nil,
                releaseDate: nil,
                posterPath: nil,
                backdropPath: nil,
                voteAverage: nil,
                popularity: nil,
                voteCount: nil,
                isFavorite: false,
                genreIds: nil
            )
        ])
        
        viewModel.applyFavoriteChange(movieId: 2, isFavorite: true)
        
        XCTAssertFalse(viewModel.movies[0].isFavorite ?? true)
        XCTAssertTrue(viewModel.movies[1].isFavorite ?? false)
    }
    
    func testGetFavoriteMoviesReturnsOnlyFavorites() async {
        repository.favoritesResult = [
            Movie(
                id: 5,
                title: "Fav Movie",
                overview: nil,
                releaseDate: nil,
                posterPath: nil,
                backdropPath: nil,
                voteAverage: nil,
                popularity: nil,
                voteCount: nil,
                isFavorite: true,
                genreIds: nil
            )
        ]
        
        await viewModel.getFavoriteMovies()
        
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertTrue(viewModel.movies.first?.isFavorite ?? false)
    }
    
    func testSearchWithNoResults() async {
        repository.searchResult = []
        
        viewModel.search(query: "Nothing")
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertTrue(viewModel.movies.isEmpty)
    }
    
    func testSearchSetsErrorMessageOnFailure() async {
        repository.shouldThrowError = true
        
        viewModel.search(query: "Fail")
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
