//
//  SwagAdminApp.swift
//  SwagAdmin
//
//  Created by Kazim Ahmad on 19/01/2026.
//

import SwiftUI

@main
struct SwagAdminApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
