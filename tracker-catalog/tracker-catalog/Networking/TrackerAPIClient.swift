//
//  TrackerAPIClient.swift
//  btc-wallet
//
//  Created by Erik Egers on 2026/03/10.
//

import Foundation

protocol TrackerClient {
    func getItems() async throws -> ItemsResponse
    func getDetails(id: String) async throws -> DetailsResponse
}

final class TrackerAPIClient: TrackerClient {

    private let networkManager: NetworkManager
    private let baseURL = "https://mock.api/tracker"

    init(session: URLSession = .shared) {
        self.networkManager = NetworkManager(session: session)
    }

    func getItems() async throws -> ItemsResponse {
        let url = URL(string: "\(baseURL)/items")
        return try await networkManager.fetchRequest(url: url)
    }

    func getDetails(id: String) async throws -> DetailsResponse {
        let url = URL(string: "\(baseURL)/details/\(id)")
        return try await networkManager.fetchRequest(url: url)
    }
}
