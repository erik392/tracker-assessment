//
//  TrackerDetailsViewModel.swift
//  tracker-catalog
//
//  Created by Erik Egers on 2026/04/10.
//

import Foundation
import Combine

@MainActor
class TrackerDetailsViewModel: ObservableObject {
    
    enum State {
        case loading
        case loaded(DetailsResponse)
        case failed
    }
    
    private let apiClient: TrackerClient
    private let trackerId: String
    
    // MARK: - Published Properties
    
    @Published var state: State = .loading
    
    // MARK: - Initializer
    init(trackerId: String,
        apiClient: TrackerClient) {
        self.trackerId = trackerId
        self.apiClient = apiClient
    }
    
    func loadDetails() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let details = try await apiClient.getDetails(id: trackerId)
            state = .loaded(details)
        } catch {
            state = .failed
            print("Failed to load details: \(error)")
        }
    }
}
