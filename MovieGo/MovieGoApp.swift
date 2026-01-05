//
//  MovieGoApp.swift
//  MovieGo
//
//  Created by Pedro Luis Martins Coelho on 05/01/26.
//

import SwiftUI

@main
struct MovieGoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
