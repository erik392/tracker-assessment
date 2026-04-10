//
//  ListViewModel.swift
//  tracker-catalog
//
//  Created by Erik Egers on 2026/04/09.
//

import Foundation
import Combine

@MainActor
class TrackerListViewModel: ObservableObject {
    
    enum State {
        case loading
        case loaded([TrackerItem])
        case failed
    }

    private let apiClient: TrackerClient
    
    // MARK: - Published Properties
    @Published var state: State = .loading
    
    // MARK: - Initializer
    init(apiClient: TrackerClient) {
        self.apiClient = apiClient
    }
    
    func loadItems() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let items = try await apiClient.getItems().items
            state = .loaded(items)
        } catch {
            state = .failed
        }
    }
}
