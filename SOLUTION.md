SOLUTION.md


# OVERVIEW


This is a SwiftUI Tracker Catalog app that lets users:
- View a list of trackers
- Search and filter trackers
- View tracker details
- Mark items as favourites

It is built using MVVM and async/await networking.

# ARCHITECTURE

Views (SwiftUI)
→ ViewModels (state + logic)
→ API Client (network layer)
→ NetworkManager

- Views are UI only
- ViewModels handle logic and state
- API layer is abstracted for testability

# STATE MANAGEMENT

Uses explicit state instead of optionals:

- loading
- loaded(data)
- failed

This makes UI states clear and predictable.

# FAVOURITES

Favourites are stored in a shared FavouritesStore using EnvironmentObject.

- One shared source of truth
- Updates reflect across all screens automatically

Trade-off:
- Requires correct app-level injection

# FILTERING

Filtering is done using a computed property:
- filters by name, category, and tags
- returns an empty array if no matches

Trade-off:
- Runs on each access (fine for small datasets)

# NETWORKING

Uses a protocol-based API layer (TrackerClient):
- Supports mocking for tests
- Keeps networking separate from UI

Trade-off:
- Slightly more boilerplate

# TESTING

Tests cover:
- ViewModels
- API decoding
- Filtering logic
- State changes

Focus is on business logic, not UI.

# KEY DESIGN CHOICES

- EnvironmentObject for shared favourites
- Enum state instead of optionals
- Computed filtering instead of stored results
- Mocked API client for testability

Trade-offs:
- Some added boilerplate
- Requires careful dependency setup

# SUMMARY

The app prioritises:
- Simple and clear state management
- Testable architecture
- SwiftUI-native patterns
- Maintainable structure
