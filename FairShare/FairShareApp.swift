//
//  FairShareApp.swift
//  FairShare
//
//  Created by Stephanie Ramirez on 5/6/24.
//

import SwiftUI

@main
struct FairShareApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
