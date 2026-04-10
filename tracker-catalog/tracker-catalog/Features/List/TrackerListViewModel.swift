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
    
    private let apiClient: TrackerClient
    
    // MARK: - Published Properties
    @Published var items: [TrackerItem] = []
    
    // MARK: - Initializer
    init(apiClient: TrackerClient) {
        self.apiClient = apiClient
    }
    
    func loadItems() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            items = try await apiClient.getItems().items
        } catch {
            print(error)
        }
    }
}
