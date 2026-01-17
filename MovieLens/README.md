MovieLens iOS App

MovieLens is a modern iOS application that allows users to search, view, and favorite movies using The Movie Database (TMDb) API. The app supports offline caching with Realm, dynamic favorite tracking, and is built with Combine, Swift concurrency, and UIKit.

The project follows a clean, modular architecture suitable for scaling and testing.

⸻

Features
    •    Search movies via TMDb API.
    •    View detailed movie information.
    •    Mark/unmark movies as favorites.
    •    Favorites persist offline using Realm.
    •    Offline-first support with cached data.
    •    Tab-based navigation with Search and Favorites.
    •    Pagination.
    •    Real-time UI updates using Combine.

⸻

Architecture

MovieLens uses MVVM + Repository pattern:

┌─────────────────┐
│  ViewController │
│  (UI Layer)     │
└───────┬─────────┘
        │ Bind to @Published
        ▼
┌───────────────┐
│ ViewModel     │
│ (Business)    │
└───────┬───────┘
        │ Calls
        ▼
┌───────────────┐
│ Repository    │
│ (Data Layer)  │
└───────┬───────┘
        │ Reads/Writes
        ▼
┌───────────────┐
│ Realm/Network │
└───────────────┘

    •    ViewController: Handles UI and user interactions.
    •    ViewModel: Holds state via @Published properties; reacts to user input.
    •    Repository: Fetches data from network or local cache.
    •    RealmService: Stores offline data and favorite status.
    •    NotificationCenter: Propagates favorite changes to update UI efficiently.

⸻

Dependencies
    •    Combine – Reactive programming for state updates.
    •    RealmSwift – Local persistent storage.
    •    UIKit – UI components and navigation.
    •    Swift Concurrency – Async/await for network operations.

⸻

Project Structure

MovieLens/
├─ Models/               # Movie, MovieSearchResponse, RealmMovie
├─ ViewModels/           # SearchViewModel, DetailViewModel
├─ Repositories/         # MovieRepository, NetworkService
├─ Views/                # SearchViewController, DetailViewController, MovieTableViewCell
├─ Services/             # RealmService, SMNetworkMonitor
├─ Resources/            # Assets, Storyboards
├─ MovieLensTests/       # Unit tests
├─ MovieLensUITests/     # UI tests


⸻

Setup
    1.    Clone the repository:

git clone https://github.com/immortalsantee/movie-lens.git
cd MovieLens-iOS

    2.    Open in Xcode 16+:

open MovieLens.xcodeproj

    3.    Set your TMDb API key in Network/Endpoint.swift:

let apiKey = "YOUR_TMDB_API_KEY"

    4.    Build and run on simulator or device.

⸻

Running Tests

Unit Tests
    •    Located in MovieLensTests.
    •    Run via Cmd+U in Xcode.
    •    Example: SearchViewModelTests validates search results, favorites, and clearing movies.

Usage

Marking Favorites
    1.    Search for a movie.
    2.    Tap the cell to open DetailViewController.
    3.    Tap the heart button in the navigation bar.
    4.    Return to the list and see the favorite badge appear.
    5.    Switch to Favorites tab to view all favorite movies.

⸻

Future Improvements
    •    Implement caching expiration policy.
    •    Add sorting and filtering options.
    •    Migrate detail screens to SwiftUI.
    •    Add setting view to clear cached files.   

⸻

Contributing
    •    Follow MVVM + Repository architecture.
    •    Add unit tests for any new feature.
    •    Add UI tests for user-facing interactions.

⸻

License

MIT License © 2026 Santosh Maharjan
