//
//  SignUpViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 21.01.2025.
//

import Foundation
import Combine
import SwiftUI
import AuthenticationServices

class SignUpViewModel: BaseViewModel {
    @Published var userName = ""
    @Published var name = ""
    @Published var surname = ""
    @Published var password = ""
    @Published var email = ""
    @Published var success : Bool = false
    @Published var loading : Bool = false
    @Published var error = ""
    @Published var showAllert: Bool = false
    
    func signUpEmail() {
        Task {
            do{
                try await AuthManager.shared.signOut()
            }catch{
                print("")
            }
        }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.error = getLocalizedString(StringKey.email_empty_error)
            self.showAllert = true
            return
        }
        
        if userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.error = getLocalizedString(StringKey.username_empty_error)
            self.showAllert = true
            return
        }
        
        if password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.error = getLocalizedString(StringKey.password_empty_error)
            self.showAllert = true
            return
        }
        
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.error = getLocalizedString(StringKey.full_name_empty_error)
            self.showAllert = true
            return
        }
        if surname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.error = getLocalizedString(StringKey.full_name_empty_error)
            self.showAllert = true
            return
        }
        
        getDataCall(
            dataCall: { try await AuthManager.shared.signUpWithEmail(email: self.email, password: self.password)},
            onSuccess: { result in
                self.saveFirebase()
            },
            onLoading: {self.loading = true},
            onError: {error in
                self.showAllert = true
                self.error = error?.localizedDescription ?? String(describing: StringKey.unknown_error)
                self.loading = false
            }
        )
    }
    private func saveFirebase(){
        getDataCall {
            try await FirestorageManager.shared.updateProfile(name: self.name, surname: self.surname, email: self.email, phoneNumber: nil)
        } onSuccess: { value in
            self.success = true
            self.loading = false
            self.showAllert = false
        } onLoading: {
            self.loading = true
        } onError: { error in
            self.showAllert = true
            self.error = error?.localizedDescription ?? String(describing: StringKey.unknown_error)
            self.loading = false
        }
    }
    
    
    func signInWithGoogle() {
        
        getDataCall {
            guard let user = try await GoogleSignInManager.shared.signInWithGoogle() else {
                throw NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Google giriş başarısız"])
            }
            return try await AuthManager.shared.googleAuth(user)
        } onSuccess: { result in
            if let result = result {
                self.loading = false
                print("GoogleSignInSuccess: \(result.user.uid)")
                self.success = true
            }
        } onLoading: {
            self.loading = true
        } onError: { error in
            self.error = error?.localizedDescription ?? String(describing: StringKey.unknown_error)
            self.loading = false
        }
    }
    
    func signInWithApple(){
        getDataCall {
            return try await withCheckedThrowingContinuation { continuation in
                AppleSignInDelegate.shared.completion = { result in
                        switch result {
                        case .success(_):
                            continuation.resume(returning: result)
                        case .failure(let error):
                            continuation.resume(throwing: error) // Burada sadece hata fırlatıyoruz.
                        }
                    }
                AppleSignInManager.shared.startSignInAppleFlow()
            }
            
        } onSuccess: { result in
            self.handleAppleID(result)
        } onLoading: {
            self.loading = true
        } onError: { error in
            self.error = error?.localizedDescription ?? String(describing: StringKey.unknown_error)
            self.loading = false
        }

    }
    
    private func handleAppleID(_ result: Result<ASAuthorization, Error>) {
        if case let .success(auth) = result {
            guard let appleIDCredentials = auth.credential as? ASAuthorizationAppleIDCredential else {
                print("AppleAuthorization failed: AppleID credential not available")
                return
            }

            Task {
                do {
                    let result = try await AuthManager.shared.appleAuth(
                        appleIDCredentials,
                        nonce: AppleSignInManager.nonce
                    )
                    if result != nil {
                        self.success = true
                    }
                } catch {
                    print("AppleAuthorization failed: \(error)")
                    // Here you can show error message to user.
                }
            }
        }
        else if case let .failure(error) = result {
            print("AppleAuthorization failed: \(error)")
            // Here you can show error message to user.
        }
    }
    
}
