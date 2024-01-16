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
    @State var email: String = ""
    @State var password: String = ""
    @State private var showSignUp: Bool = true
    @State private var showAlertView: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    
    init() {
        FirebaseApp.configure()
        Purchases.configure(withAPIKey: "")
        Purchases.logLevel = .debug
    }
    
    var body: some Scene {
        WindowGroup {
            SignUpView(showSignUp: $showSignUp, email: $email, password: $password, showAlertView: $showAlertView, alertTitle: $alertTitle, alertMessage: $alertMessage)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
