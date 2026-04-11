//
//  tracker_catalogApp.swift
//  tracker-catalog
//
//  Created by Erik Egers on 2026/04/08.
//

import SwiftUI
import CoreData

@main
struct tracker_catalogApp: App {
    @StateObject private var favourites = FavouritesStore()

    private let viewModel: TrackerListViewModel

    init() {
        let session = try! MockSessionFactory.makeMockSession()
        let client = MockTrackerAPIClient(session: session)
        self.viewModel = TrackerListViewModel(apiClient: client)
    }

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: viewModel)
                .environmentObject(favourites)
        }
    }
}

struct RootView: View {
    let viewModel: TrackerListViewModel

    var body: some View {
        NavigationStack {
            TrackerListView(viewModel: viewModel)
        }
    }
}
