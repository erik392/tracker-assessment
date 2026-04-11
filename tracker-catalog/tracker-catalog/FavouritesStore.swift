//
//  FavouritesStore.swift
//  tracker-catalog
//
//  Created by Erik Egers on 2026/04/10.
//

import Foundation
import Combine

final class FavouritesStore: ObservableObject {
    @Published private(set) var favouriteIDs: Set<String> = []

    private let key = "favourite_ids"

    init() {
        let saved = UserDefaults.standard.stringArray(forKey: key) ?? []
        favouriteIDs = Set(saved)
    }

    func toggle(_ id: String) {
        if favouriteIDs.contains(id) {
            favouriteIDs.remove(id)
        } else {
            favouriteIDs.insert(id)
        }
        save()
    }

    func isFavourite(_ id: String) -> Bool {
        favouriteIDs.contains(id)
    }

    private func save() {
        UserDefaults.standard.set(Array(favouriteIDs), forKey: key)
    }
}
