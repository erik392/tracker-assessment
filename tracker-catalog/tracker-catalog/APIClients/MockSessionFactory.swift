//
//  MockSessionFactory.swift
//  tracker-catalog
//
//  Created by Erik Egers on 2026/04/09.
//

import Foundation

final class MockSessionFactory {

    static func makeMockSession() throws -> URLSession {

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]

        MockURLProtocol.mockResponses = try Self.loadMockResponses()

        return URLSession(configuration: config)
    }

    // MARK: - Mock Data Setup

    private static func loadMockResponses() throws -> [String: Data] {

        func load(_ name: String) throws -> Data {
            guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
                throw MockError.fileNotFound(name)
            }
            return try Data(contentsOf: url)
        }

        return [
            "/tracker/items": try load("items"),
            "/tracker/details/trk-1001": try load("details_trk-1001"),
            "/tracker/details/trk-1002": try load("details_trk-1002"),
            "/tracker/details/trk-1003": try load("details_trk-1003"),
            "/tracker/details/trk-1004": try load("details_trk-1004"),
            "/tracker/details/trk-1005": try load("details_trk-1005"),
            "/tracker/details/trk-1006": try load("details_trk-1006")
        ]
    }
}

// MARK: - Errors

enum MockError: Error {
    case fileNotFound(String)
}
