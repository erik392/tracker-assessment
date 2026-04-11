//
//  MockTrackerAPIClient.swift
//  btc-wallet
//
//  Created by Erik Egers on 2026/03/10.
//

import Foundation

protocol TrackerClient {
    func getItems() async throws -> ItemsResponse
    func getDetails(id: String) async throws -> DetailsResponse
}

final class MockTrackerAPIClient: TrackerClient {

    private let networkManager: NetworkManager
    private let shouldSucceed: Bool
    private let baseURL = "https://mock.api/tracker"

    init(session: URLSession = .shared,
         shouldSucceed: Bool = true) {
        self.networkManager = NetworkManager(session: session)
        self.shouldSucceed = shouldSucceed
    }

    func getItems() async throws -> ItemsResponse {
        guard shouldSucceed else {
            throw URLError(.badServerResponse)
        }
        let url = URL(string: "\(baseURL)/items")
        return try await networkManager.fetchRequest(url: url)
    }

    func getDetails(id: String) async throws -> DetailsResponse {
        guard shouldSucceed else {
            throw URLError(.badServerResponse)
        }
        let url = URL(string: "\(baseURL)/details/\(id)")
        return try await networkManager.fetchRequest(url: url)
    }
}
