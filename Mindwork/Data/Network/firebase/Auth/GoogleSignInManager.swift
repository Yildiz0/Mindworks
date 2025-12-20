//
//  GoogleSignInManager.swift
//  Tendria
//
//  Created by Yakup Kavak on 25.01.2025.
//

import Foundation
import GoogleSignIn
import FirebaseCore

class GoogleSignInManager {

    static let shared = GoogleSignInManager()

    typealias GoogleAuthResult = (GIDGoogleUser?, Error?) -> Void

    private init() {}

    @MainActor
    func signInWithGoogle() async throws -> GIDGoogleUser? {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            return nil //firebase app'in clien id'sini alıyorum.
        }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config //google oturum açma configi tamamlanıyor
        // 1.
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            return try await GIDSignIn.sharedInstance.restorePreviousSignIn()//daha önce giriş varsa girdiği bilgiyi dön
        } else {
            // 2.
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }//ilk önce ekranı alıyorum
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return nil }
            //sonra ana ekran controllere erişip, burada göstereceğiz.
            // 3.
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            return result.user
        }
    }
    
    // 4.
    func signOutFromGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
}
