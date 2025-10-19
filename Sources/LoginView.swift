//
//  LoginView.swift
//  MSLoginKit
//
//  Created by mohammed Shafiullah on 05/10/25.
//

import SwiftUI

public struct LoginView: View {
    @Binding public var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var showSignup = false
    @State private var errorMessage = ""

    // ✅ Add this explicit public initializer:
    public init(isLoggedIn: Binding<Bool>) {
        self._isLoggedIn = isLoggedIn
    }
    public var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .bold()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button("Login") {
                login()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            Button("Don't have an account? Sign Up") {
                showSignup = true
            }
            .foregroundColor(.white)
        }
        .padding()
        .sheet(isPresented: $showSignup) {
            SignupView(isSignedUp: $isLoggedIn)
        }
    }
    }

    private func login() {
            AuthService.shared.login(email: email, password: password) { result in
                switch result {
                case .success(let user):
                    print("✅ Logged in as: \(user.email ?? "")")
                    isLoggedIn = true
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    print("❌ Login failed:", error.localizedDescription)
                }
            }
        }
    }
