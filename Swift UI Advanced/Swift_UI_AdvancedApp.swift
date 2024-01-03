//
//  Swift_UI_AdvancedApp.swift
//  Swift UI Advanced
//
//  Created by Alyaxey Valevich on 03/11/2023.
//

import SwiftUI
import Firebase
import RevenueCat

@main
struct Swift_UI_AdvancedApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
        Purchases.configure(withAPIKey: "")
        Purchases.logLevel = .debug
    }
    
    var body: some Scene {
        WindowGroup {
            SignUpView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
