//
//  AuthRepository.swift
//  Tendria
//
//  Created by Yakup Kavak on 23.01.2025.
//

import Foundation
import FirebaseAuth

class AuthRepository{
    let auth = Auth.auth()
    func signUp(email: String, password: String) async throws {
        try await auth.createUser(withEmail: email, password: password)
    }
    func signIn(email: String, password: String) async throws{
        try await auth.signIn(withEmail: email, password: password)
    }
    func signOut() throws{
        try auth.signOut()
    }
}
