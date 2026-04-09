//
//  DetailsResponse.swift
//  tracker-catalog
//
//  Created by Erik Egers on 2026/04/09.
//

import Foundation

// MARK: - DetailsResponse
struct DetailsResponse: Codable {
    let id, name, category, summary: String
    let details, status: String
    let tags: [String]
    let lastUpdated: Date
    let specs: Specs
}

// MARK: - Specs
struct Specs: Codable {
    let battery: String
    let connectivity: [String]
    let dimensions: String
}
