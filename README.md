# MovieLens iOS App

MovieLens is a modern iOS application that allows users to **search, view, and favorite movies** using **The Movie Database (TMDb) API**. The app supports offline caching with **Realm**, dynamic favorite tracking, and is built with **Combine**, **Swift concurrency**, and **UIKit**.

The project follows a **clean, modular architecture** suitable for scaling and testing.

---

## Features

* Search movies via TMDb API.
* View detailed movie information.
* Mark/unmark movies as favorites.
* Favorites persist offline using Realm.
* Offline-first support with cached data.
* Tab-based navigation with Search and Favorites.
* Pagination and pull-to-refresh support.
* Real-time UI updates using Combine.

---

## Architecture

MovieLens uses **MVVM + Repository pattern**:

```
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
```

* **ViewController**: Handles UI and user interactions.
* **ViewModel**: Holds state via `@Published` properties; reacts to user input.
* **Repository**: Fetches data from network or local cache.
* **RealmService**: Stores offline data and favorite status.
* **NotificationCenter**: Propagates favorite changes to update UI efficiently.

---

## Dependencies

* **Combine** – Reactive programming for state updates.
* **RealmSwift** – Local persistent storage.
* **UIKit** – UI components and navigation.
* **Swift Concurrency** – Async/await for network operations.

---

## Project Structure

```
MovieLens/
├─ App/
├─ Data/
├─ Domain/
├─ Network/
├─ Presentation/
├─ Repository/
├─ Supporting/
├─ MovieLensTests/
└─ MovieLensUITests/
```

---

## Setup

1. Clone the repository:

```bash
git clone https://github.com/immortalsantee/movie-lens.git
cd movie-lens
```

2. Open in Xcode 16+:

```bash
open MovieLens.xcodeproj
```

3. Set your TMDb API key in `Endpoint.swift`:

```swift
static let apiKey = "YOUR_TMDB_API_KEY"
```

4. Build and run on simulator or device.

---

## Running Tests

### Unit Tests

* Located in **`MovieLensTests`**.
* Run via **Cmd+U** in Xcode.
* Example: `SearchViewModelTests` validates search results, favorites, and clearing movies.

### UI Tests

* Located in **`MovieLensUITests`**.
* The app uses a clean **temporary Realm database** during UI tests:

```swift
app.launchArguments = ["-UITestMode"]
```

* Example: `FavoriteUITests` verifies marking/unmarking favorites, tab switching, and favorite badge persistence.

---

## Realm Test Configuration

For deterministic UI testing:

```swift
enum SMAppEnvironment {
    static let isUITest: Bool =
        ProcessInfo.processInfo.arguments.contains("-UITestMode")
}
```

* UI tests use a **temporary Realm file** at runtime.
* `deleteRealmIfMigrationNeeded = true` ensures a clean state for each run.
* Production database remains untouched.

---

## Usage

### Marking Favorites

1. Search for a movie.
2. Tap the cell to open **DetailViewController**.
3. Tap the heart button in the navigation bar.
4. Return to the list and see the favorite badge appear.
5. Switch to **Favorites tab** to view all favorite movies.

---

## Future Improvements

* Implement caching expiration policy.
* Add sorting and filtering options.
* Add video trailer
* Display more detailed movie information (cast, runtime, similar movies)
* User profiles and watchlists
* Recently viewed movies
* Movie ratings and reviews

---

## License

MIT License © 2026 Santosh Maharjan
