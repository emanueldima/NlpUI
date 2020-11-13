//
//  NlpUIApp.swift
//  NlpUI
//
//  Created by Emanuel Dima on 13.11.20.
//

import SwiftUI

@main
struct NlpUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
