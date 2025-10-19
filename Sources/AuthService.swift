//
//  AuthService.swift
//  MSLoginKit
//
//  Created by mohammed Shafiullah on 05/10/25.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import Combine
import FirebaseFirestore

public class AuthService: ObservableObject {
    @Published public var user: User?
    @Published public var errorMessage: String?
    @Published var isAuthenticated = false

    public static var shared = AuthService()
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    private let db = Firestore.firestore()

    private init() {
        // ✅ Ensure Firebase is configured before using Auth
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        // Keep track of auth state changes
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                AuthService.shared.isAuthenticated = (user != nil)
                self?.user = user
            }
        }
    }

    // MARK: - Login
      public func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
          Auth.auth().signIn(withEmail: email, password: password) { result, error in
              if let error = error {
                  completion(.failure(error))
                  return
              }

              if let user = result?.user {
                  self.user = user
                  completion(.success(user))
              }
          }
      }

      // MARK: - Logout
      public func logout() {
          do {
              try Auth.auth().signOut()
              user = nil
              print("✅ Logged out successfully")
          } catch {
              print("❌ Logout failed: \(error.localizedDescription)")
          }
      }

    // MARK: - Signup
    public func signup(
        email: String,
        password: String,
        phoneNumber: String,
        dateOfBirth: Date,
        completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            print("createUser result:", result ?? "Nil data")
            print("createUser error:", error ?? "No Error")
            if let error = error {
                DispatchQueue.main.async {
                    print("❌ Firebase Auth Error:", error.localizedDescription)
                    completion(.failure(error))
                }
                return
            }

            guard let firebaseUser = result?.user else {
                let customError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase user not found"])
                DispatchQueue.main.async {
                    completion(.failure(customError))
                }
                return
            }

            let userData: [String: Any] = [
                "uid": firebaseUser.uid,
                "email": email,
                "phone": phoneNumber,
                "dateOfBirth": Timestamp(date: dateOfBirth),
                "createdAt": Timestamp(date: Date())
            ]

            let dbs = Firestore.firestore()
            dbs.collection("users").document(firebaseUser.uid).setData(userData) { err in
                print("🟡 Firebase Auth created user: \(String(describing: result?.user.uid))")
                if let err = err {
                    print("❌ Firestore error:", err)
                    completion(.failure(err))
                } else {
                    DispatchQueue.main.async {
                        print("✅ Firestore write success for user:", firebaseUser.uid)
                        // Update local user state safely
                        self?.user = firebaseUser
                        AuthService.shared.isAuthenticated  = true
                        completion(.success(firebaseUser))
                    }
                }
            }
        }
    }

  
}
