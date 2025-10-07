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
    public static let shared = AuthService()
    private let db = Firestore.firestore()
    
    @Published public var user: User?
    @Published public var errorMessage: String?

    private init() {
        // ✅ Ensure Firebase is configured before using Auth
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        // Keep track of auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
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
    public func signup(email: String, password: String,phoneNumber: String, dateOfBirth :Date, completion: @escaping (Result<User, Error>) -> Void) {
           Auth.auth().createUser(withEmail: email, password: password ) { result, error in
               if let error = error {
                   print("Firebase Auth Error:", error._userInfo ?? error.localizedDescription ?? "Unknown")
                   completion(.failure(error))
                   return
               }

               guard let firebaseUser = result?.user else { return }

               // ✅ Create user document in Firestore
               let userData: [String: Any] = [
                   "uid": firebaseUser.uid,
                   "email": email,
                   "phone": phoneNumber,
                   "dateOfBirth": Timestamp(date: dateOfBirth),
                   "createdAt": Timestamp(date: Date())
               ]
               self.db.collection("users").document(firebaseUser.uid).setData(userData) { err in
                   if let err = err {
                       completion(.failure(err))
                   } else {
                       completion(.success(firebaseUser))
                   }
               }
           }
       }

  
}
