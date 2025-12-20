//
//  ResetPasswordViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 11.02.2025.
//

import Foundation
import SwiftUI
import FirebaseAuth

class ResetPasswordViewModel: BaseViewModel{
    @Published var success = false
    @Published var loading = false
    @Published var error: ResetPasswordError?
    @Published var currentPassword = ""
    @Published var newPassword = ""
    @Published var againPassword = ""
    
    func resetPassword() {
        
        if checkInput() {
            guard let user = Auth.auth().currentUser else {
                print("Kullanıcı oturumu yok")
                return
            }

            // Kullanıcının kimliğini yeniden doğrula
            let email = user.email
            guard let email = email else { return }
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

            loading = true

            user.reauthenticate(with: credential) { [weak self] authResult, error in
                guard let self = self else { return }
                if let error = error {
                    print("Kimlik doğrulama hatası: \(error.localizedDescription)")
                    self.error = .invalidCurrentPassword
                    self.loading = false
                    return
                }

                // Şifreyi güncelle
                user.updatePassword(to: self.newPassword) { error in
                    self.loading = false
                    if let error = error {
                        print("Şifre güncelleme hatası: \(error.localizedDescription)")
                        self.error = .weakPassword // örnek hata
                    } else {
                        self.success = true
                        self.error = nil
                        print("Şifre başarıyla değiştirildi")
                    }
                }
            }
        }
    }

    
    func checkInput() -> Bool {
        // Alan boş mu?
        guard !currentPassword.isEmpty, !newPassword.isEmpty, !againPassword.isEmpty else {
            error = .emptyFields
            return false
        }
        
        // Şifre uyuşması
        guard newPassword == againPassword else {
            error = .passwordsDoNotMatch
            return false
        }
        
        // Şifre gücü
        guard newPassword.count >= 8,
              newPassword.range(of: "[A-Z]", options: .regularExpression) != nil else {
            error = .weakPassword
            return false
        }
        
        return true
    }
}

enum ResetPasswordError: LocalizedError {
    case passwordsDoNotMatch
    case weakPassword
    case emptyFields
    case invalidCurrentPassword
    case updateFailed
    case firebaseUserNotFound
    case unknown
    
    var errorDescription: LocalizedStringKey {
        switch self {
        case .passwordsDoNotMatch:
            return StringKey.error_passwords_do_not_match
        case .weakPassword:
            return StringKey.error_weak_password
        case .emptyFields:
            return StringKey.error_empty_fields
        case .invalidCurrentPassword:
            return StringKey.error_invalid_current_password
        case .updateFailed:
            return StringKey.error_update_failed
        case .firebaseUserNotFound:
            return StringKey.error_user_not_found
        case .unknown:
            return StringKey.error_unknown
        }
    }
}
