//
//  Swift_UI_AdvancedApp.swift
//  Swift UI Advanced
//
//  Created by Alyaxey Valevich on 03/11/2023.
//

import SwiftUI
import Firebase

@main
struct Swift_UI_AdvancedApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SignUpView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
