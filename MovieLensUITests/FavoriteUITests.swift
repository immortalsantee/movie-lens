//
//  FavoriteUITests.swift
//  MovieLensUITests
//

import XCTest

final class FavoriteUITests: XCTestCase {

    private var app: XCUIApplication!

    // MARK: - Setup

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-UITestMode"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Test

    func testFavoriteToggleReflectsOnMovieList() {
        searchForMovie("Spider man")

        // Mark as favorite
        toggleFavoriteAndVerifyBadge(expectedVisible: true)

        // Verify in Favorites tab
        switchToFavoritesTab()
        verifyFavoritesCount(expected: 1)

        // Switch back to Search
        switchToSearchTab()

        // Unfavorite
        toggleFavoriteAndVerifyBadge(expectedVisible: false)

        // Verify Favorites empty
        switchToFavoritesTab()
        verifyFavoritesCount(expected: 0)
    }
}

// MARK: - Helper Methods (Senior-Level Extraction)

private extension FavoriteUITests {

    /// Searches movie using search bar
    func searchForMovie(_ query: String) {
        let searchField = app.searchFields["Search any movies"]
        XCTAssertTrue(
            searchField.waitForExistence(timeout: 3),
            "Search bar should exist"
        )

        searchField.tap()
        searchField.typeText(query + "\n")
    }

    /// Toggles favorite from detail screen and verifies badge on list
    func toggleFavoriteAndVerifyBadge(expectedVisible: Bool) {

        let firstCell = firstMovieCell()
        firstCell.tap()

        toggleFavoriteOnDetail()

        navigateBackToList()

        verifyFavoriteBadgeVisibility(
            in: firstMovieCell(),
            shouldBeVisible: expectedVisible
        )
    }
    

    /// Returns first movie cell
    func firstMovieCell() -> XCUIElement {
        let cell = app.tables.cells.firstMatch
        XCTAssertTrue(
            cell.waitForExistence(timeout: 8),
            "Movie cell should appear"
        )
        return cell
    }

    /// Taps favorite button on detail screen
    func toggleFavoriteOnDetail() {
        let favoriteButton = app.navigationBars.buttons.element(boundBy: 1)

        XCTAssertTrue(
            favoriteButton.waitForExistence(timeout: 3),
            "Favorite button should exist on detail screen"
        )

        favoriteButton.tap()
    }

    /// Navigates back to movie list
    func navigateBackToList() {
        let backButton = app.navigationBars.buttons.element(boundBy: 0)

        XCTAssertTrue(
            backButton.waitForExistence(timeout: 3),
            "Back button should exist"
        )

        backButton.tap()
    }

    /// Verifies favorite badge visibility
    func verifyFavoriteBadgeVisibility(in cell: XCUIElement, shouldBeVisible: Bool) {
        let badge = cell.images["smt_favorite_badge"]

        if shouldBeVisible {
            XCTAssertTrue(
                badge.waitForExistence(timeout: 3),
                "Favorite badge should be visible on movie cell"
            )
        } else {
            XCTAssertFalse(
                badge.exists,
                "Favorite badge should not be visible on movie cell"
            )
        }
    }
    
    func switchToFavoritesTab() {
        let favoritesTab = app.tabBars.buttons.element(boundBy: 1)

        XCTAssertTrue(
            favoritesTab.waitForExistence(timeout: 3),
            "Favorites tab should exist"
        )

        favoritesTab.tap()
    }
    
    func switchToSearchTab() {
        let searchTab = app.tabBars.buttons.element(boundBy: 0)

        XCTAssertTrue(
            searchTab.waitForExistence(timeout: 3),
            "Search tab should exist"
        )

        searchTab.tap()
    }
    
    func verifyFavoritesCount(expected: Int) {
        let table = app.tables.firstMatch

        XCTAssertTrue(
            table.waitForExistence(timeout: 3),
            "Favorites table should exist"
        )

        XCTAssertEqual(
            table.cells.count,
            expected,
            "Expected \(expected) favorite movie(s)"
        )
    }
}
