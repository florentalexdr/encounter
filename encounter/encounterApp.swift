//
//  encounterApp.swift
//  encounter
//
//  Created by Florent Alexandre on 10/05/2021.
//

import SwiftUI

@main
struct encounterApp: App {
    let persistenceController = PersistenceController.preview

    var body: some Scene {
        WindowGroup {
            EncounterView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
