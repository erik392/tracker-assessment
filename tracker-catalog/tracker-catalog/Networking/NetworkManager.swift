//
//  NetworkManager.swift
//  btc-wallet
//
//  Created by Erik Egers on 2026/03/10.
//

import Foundation

final class NetworkManager {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchRequest<T: Decodable>(
        url: URL?,
        headers: [String: String] = [:]
    ) async throws -> T {
        guard let endpointUrl = url else { throw CustomError.invalidUrl }

        var request = URLRequest(url: endpointUrl)
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        return try await callRequest(with: request)
    }

    private func callRequest<T: Decodable>(
        with request: URLRequest
    ) async throws -> T {
        let (data, _) = try await session.data(for: request)
        return try decode(T.self, from: data)
    }

    private func decode<T: Decodable>(
        _ type: T.Type,
        from data: Data
    ) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw CustomError.parsingError
        }
    }
}

enum CustomError: Error {
    case invalidUrl
    case parsingError
}
