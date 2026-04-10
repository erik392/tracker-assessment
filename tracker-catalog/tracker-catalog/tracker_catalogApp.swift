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

    var body: some Scene {
        WindowGroup {
            let session = try! MockSessionFactory.makeMockSession()
            let client = TrackerAPIClient(session: session)
            TrackerListView(viewModel: TrackerListViewModel(apiClient: client))
                .environmentObject(favourites)
        }
    }
}
