//
//  TrackerListViewModel_Tests.swift
//  tracker-catalogTests
//
//  Created by Erik Egers on 2026/04/11.
//

import Foundation
import Testing
@testable import tracker_catalog

@MainActor
struct TrackerListViewModelTests {
    
    // MARK: - Helpers
    
    func makeViewModel(shouldSucceed: Bool = true) -> TrackerListViewModel {
        let session = try! MockSessionFactory.makeMockSession()
        let client = MockTrackerAPIClient(session: session,
                                          shouldSucceed: shouldSucceed)
        return TrackerListViewModel(apiClient: client)
    }
    
    // MARK: - Tests
    
    @Test
    func initialStateIsLoading() {
        
        let vm = makeViewModel()
        
        #expect(vm.state == .loading)
        #expect(vm.items.isEmpty)
        #expect(vm.searchText.isEmpty)
    }
    
    @Test
    func loadItemsSuccessSetsItemsAndLoadedState() async {
        
        let vm = makeViewModel()
        
        await vm.loadItems()
        
        #expect(vm.state == .loaded)
        #expect(vm.items.count == 6)
        #expect(vm.items[0].name == "Beacon Pro")
        #expect(vm.items[1].name == "Motion Sense X")
        #expect(vm.items[2].name == "Enviro Monitor")
    }
    
    @Test
    func loadItemsFailureSetsFailedState() async {
        
        let vm = makeViewModel(shouldSucceed: false)
        
        await vm.loadItems()
        
        #expect(vm.state == .failed)
        #expect(vm.items.isEmpty)
    }
    
    @Test
    func filteredItemsReturnsAllWhenSearchEmpty() async {
        
        let vm = makeViewModel()
        
        await vm.loadItems()
        
        #expect(vm.filteredItems.count == 6)
    }
    
    @Test
    func filteredItemsFiltersByName() async {
        
        let vm = makeViewModel()
        
        await vm.loadItems()
        
        vm.searchText = "Beacon Pro"
        
        #expect(vm.filteredItems.count == 1)
        #expect(vm.filteredItems.first?.name == "Beacon Pro")
    }
    
    @Test
    func filteredItemsFiltersByCategory() async {
        
        let vm = makeViewModel()
        
        await vm.loadItems()
        
        vm.searchText = "Gateways"
        
        #expect(vm.filteredItems.count == 1)
        #expect(vm.filteredItems.first?.name == "Gateway Lite")
    }
    
    @Test
    func filteredItemsFiltersByTags() async {
        
        let vm = makeViewModel()
        
        await vm.loadItems()
        
        vm.searchText = "asset"
        
        #expect(vm.filteredItems.count == 1)
        #expect(vm.filteredItems.first?.name == "Asset Tag Mini")
    }
    
    @Test
    func filteredItemsIsCaseInsensitive() async {
        
        let vm = makeViewModel()
        
        await vm.loadItems()
        
        vm.searchText = "BEACON PRO"
        
        #expect(vm.filteredItems.count == 1)
        #expect(vm.filteredItems.first?.name == "Beacon Pro")
    }
    
    @Test
    func filteredItemsReturnsEmptyWhenNoMatch() async {

        let vm = makeViewModel()
        
        await vm.loadItems()
        
        vm.searchText = "swimming"
        
        #expect(vm.filteredItems.isEmpty)
    }
}
