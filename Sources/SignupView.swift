//
//  SignupView.swift
//  MSLoginKit
//
//  Created by mohammed Shafiullah on 05/10/25.
//

import SwiftUI

public struct SignupView: View {
    @Binding public var isSignedUp: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""

    public init(isSignedUp: Binding<Bool>) {
         self._isSignedUp = isSignedUp
     }
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textContentType(.newPassword)  // or .oneTimeCode
                    .disableAutocorrection(true)
                    .autocapitalization(.none)

            SecureField("Confirm Password", text: $confirmPassword)
                .textContentType(.newPassword)  // or .oneTimeCode
                    .disableAutocorrection(true)
                    .autocapitalization(.none)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Sign Up") {
                signUp()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            if isSignedUp {
           Text("✅ Account created successfully!")
              .foregroundColor(.green)
                           }
        }
        .padding()
    }

    private func signUp() {
           guard password == confirmPassword else {
               errorMessage = "Passwords do not match"
               return
           }

           AuthService.shared.signup(email: email, password: password) { result in
               switch result {
               case .success:
                   errorMessage = ""
                   isSignedUp = true
               case .failure(let error):
                   errorMessage = error.localizedDescription
               }
           }
       }
}
