//
//  OrganismSwiftUIApp.swift
//  OrganismSwiftUI
//
//  Created by 张文涛 on 2023/4/14.
//

import SwiftUI

@main
struct OrganismSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PetriGarden()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
