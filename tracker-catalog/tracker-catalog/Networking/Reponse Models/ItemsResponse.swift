//
//  ItemsResponse.swift
//  tracker-catalog
//
//  Created by Erik Egers on 2026/04/09.
//

import Foundation

// MARK: - ItemsResponse
struct ItemsResponse: Codable {
    let items: [TrackerItem]
}

// MARK: - Item
struct TrackerItem: Codable {
    let id, name, category, summary: String
    let details, status: String
    let tags: [String]
    let lastUpdated: Date
}
