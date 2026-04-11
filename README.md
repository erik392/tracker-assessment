# Tracker Catalog App

A SwiftUI-based iOS application for browsing a catalog of tracker devices, viewing detailed information, and managing favourites.

---

## Features

### Tracker List
- Displays a list of available tracker devices
- Supports real-time search and filtering by:
  - Name
  - Category
  - Tags
- Pull-to-refresh support for reloading data

### Tracker Details
- View detailed information about a selected tracker
- Includes:
  - Description and summary
  - Status
  - Specifications
  - Last updated timestamp

### Favourites
- Mark trackers as favourites
- Favourite state is shared across list and detail screens
- Persisted in a shared environment store

---

## Demo

![Simulator Screen Recording - iPhone 17 Pro - 2026-04-11 at 18 03 53](https://github.com/user-attachments/assets/050cc897-c52a-4d4f-8180-18a1531f07a3)

---

## Tech Stack

- Swift
- SwiftUI
- Combine / ObservableObject
- async/await networking
- MVVM architecture
- Dependency injection via `EnvironmentObject`

---

## Getting Started

### Requirements
- Xcode 15+
- iOS 16+ deployment target
- Swift 5.9+

### Run the project

1. Clone the repository:
    ```bash
    git clone https://github.com/erik392/tracker-assessment.git
2. Open the project in Xcode:
    ```bash
    open tracker-catalog.xcodeproj
4. Select a simulator or device
5. Build and run:
    ```bash
    Cmd + R
