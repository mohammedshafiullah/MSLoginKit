//
//  ExampleApp.swift
//  MSLoginKit_Example
//
//  Created by mohammed Shafiullah on 05/10/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import SwiftUI
import MSLoginKit

// So far the code authentication
@main
struct ExampleApp: App {
    @State private var isLoggedInLocal = false

    init() {
        FirebaseManager.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            if isLoggedInLocal {
                VStack(spacing: 20) {
                    Text("🎉 Welcome!")
                        .font(.title)
                    Button("Logout") {
                        AuthService.shared.logout()
                        isLoggedInLocal = false
                    }
                    .foregroundColor(.red)
                }
            } else {
                LoginView(isLoggedIn: $isLoggedInLocal)
            }
        }
    }
}
