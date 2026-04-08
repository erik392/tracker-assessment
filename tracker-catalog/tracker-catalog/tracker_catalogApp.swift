//
//  tracker_catalogApp.swift
//  tracker-catalog
//
//  Created by Erik Egers on 2026/04/08.
//

import SwiftUI
import CoreData

@main
struct tracker_catalogApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
