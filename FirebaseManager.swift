//
//  FirebaseManager.swift
//  MSLoginKit
//
//  Created by mohammed Shafiullah on 05/10/25.
//

import Foundation
import FirebaseCore  // ✅ make sure this is here

public class FirebaseManager {
    public static let shared = FirebaseManager()
    private init() {}

    /// Call this from your Example app or host app
    public func configure() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}
