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
        case loaded
        case failed
    }

    private let apiClient: TrackerClient
    
    // MARK: - Published Properties
    @Published var state: State = .loading
    @Published var items: [TrackerItem] = []
    @Published var searchText = ""
    
    // MARK: - Initializer
    init(apiClient: TrackerClient) {
        self.apiClient = apiClient
    }
    
    var filteredItems: [TrackerItem] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.category.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            }
        }
    }
    
    func loadItems() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            items = try await apiClient.getItems().items
            state = .loaded
        } catch {
            state = .failed
        }
    }
}
