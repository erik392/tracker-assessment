//
//  TrackerAPIClient_Tests.swift
//  tracker-catalogTests
//
//  Created by Erik Egers on 2026/04/11.
//

import Foundation
import Testing
@testable import tracker_catalog

@MainActor
struct TrackerAPIClientTests {
    
    @Test
    func getDetailsReturnsCorrectlyDecodedModel() async throws {
        
        let session = try! MockSessionFactory.makeMockSession()
        let client = MockTrackerAPIClient(session: session)
        
        let result = try await client.getDetails(id: "trk-1001")
        
        #expect(result.id == "trk-1001")
        #expect(result.name == "Beacon Pro")
        #expect(result.category == "Beacons")
        #expect(result.summary == "Indoor location beacon for micro-positioning.")
        #expect(result.details == "Battery-powered BLE beacon with configurable intervals.")
        #expect(result.status == "active")
        #expect(result.tags == ["ble", "indoor"])
        
        #expect(result.specs.battery == "500mAh")
        #expect(result.specs.connectivity == ["BLE"])
        #expect(result.specs.dimensions == "35x35x8mm")
        
        #expect(result.lastUpdated == ISO8601DateFormatter().date(from: "2025-01-18T10:00:00Z"))
    }
}
