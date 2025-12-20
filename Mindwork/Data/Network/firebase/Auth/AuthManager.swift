//
//  AuthManager.swift
//  Tendria
//
//  Created by Yakup Kavak on 25.01.2025.
//

import Foundation
import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseAppCheck
import FirebaseMessaging
import FirebaseFirestore


class AuthManager: ObservableObject {
    
    private var user: User?
    private var authState = AuthState.signedOut
    private var auth: Auth
    private var authStateHandle: AuthStateDidChangeListenerHandle!
    private let database = Firestore.firestore()
    @Published var isSigned = false
    
    static let shared = AuthManager()
    
    private init() {
        self.auth = Auth.auth()
        do { try auth.signOut()
        } catch {
            return
        }
        
        configureAuthStateChanges()
        verifySignInWithAppleID()
    }
    
    func getUserModel() async throws -> UserModel{
        let relationId = try await RelationRepository.shared.getRelationId()
        let documentReference = database.collection(FireDatabase.USERS_PATH)
        let querySnapshot = try await documentReference.whereField(FireDatabase.RELATION_ID, isEqualTo: relationId).getDocuments()
        do {
            for document in querySnapshot.documents{
                let data = try document.data(as: UserModel.self)
                return data
            }
        } catch {
            throw error
        }
        throw RelationError.unknown
    }
    
    func getUserID() -> String?{
        guard let userId = auth.currentUser?.uid else{
            return nil
        }
        return userId
    }
    
    func getUserMail() -> String?{
        guard let userMail = auth.currentUser?.email else{
            return nil
        }
        return userMail
    }
    
    func configureAuthStateChanges() {
        authStateHandle = auth.addStateDidChangeListener { auth, user in
            guard let currentUser = user else {
                self.isSigned = false
                print("Auth changed: \(user != nil)")
                self.updateState(user: user)
                return
            }
            self.isSigned = true
            FirestorageManager.shared.configureFcmToken()
            FirestorageManager.shared.configureUserLanguage(userID: currentUser.uid)
            print("Auth changed: \(user != nil)")
            self.updateState(user: user)
        }
    }
    
    func checkUserSession() -> Bool {
        return auth.currentUser != nil
    }
    
    func removeAuthStateListener() {
        auth.removeStateDidChangeListener(authStateHandle)
    }
    
    func updateState(user: User?) {
        self.user = user
        let isAuthenticatedUser = user != nil
        self.authState = isAuthenticatedUser ? .signedIn : .signedOut
    }
    
    func autoSignOut() async {
        do {
            try await signOut() // ✅ Otomatik çıkış yap
            print("✅ Uygulama açıldığında otomatik çıkış yapıldı")
        } catch {
            print("❌ Otomatik çıkış işlemi başarısız: \(error.localizedDescription)")
        }
    }
    
    func signOut() async throws {
        if auth.currentUser != nil {
            do {
                try auth.signOut()
            }
            catch let error as NSError{
                print("FirebaseAuthError: failed to sign out from Firebase, \(error)")
                throw mapFirebaseError(error)
            }
        }
    }
    
    //credential alıp firebaseden giriş yapmaya çalışıyor.
    private func authenticateUser(credentials: AuthCredential) async throws -> AuthDataResult? {
        guard let currentUser = auth.currentUser else {
            return try await authSignIn(credentials: credentials)
        }
        let providers = currentUser.providerData.map { $0.providerID }
        
        if providers.contains("google.com") && credentials.provider == "google.com" {
            return try await authSignIn(credentials: credentials)
        }
        else if providers.contains("apple.com") && credentials.provider == "apple.com"{
            return try await authSignIn(credentials: credentials)
        }
        else if providers.contains("password") && credentials.provider == "password" {
            return try await authSignIn(credentials: credentials)
        }
        return try await authLink(credentials: credentials)
    }
    
    private func authSignIn(credentials: AuthCredential) async throws -> AuthDataResult? {
        do {
            let result = try await auth.signIn(with: credentials)
            updateState(user: result.user) // bu kendi içimiz için.
            return result
        }
        catch {
            print("FirebaseAuthError: signIn(with:) failed. \(error)")
            throw mapFirebaseError(error)
        }
    }
    
    func signUpWithEmail(email: String, password: String) async throws -> AuthDataResult? {
        do {
            _ = try await auth.createUser(withEmail: email, password: password)
            return try await signInWithEmail(email: email, password: password)
        } catch {
            print("FirebaseAuthError: signUpWithEmail(email:password:) failed. \(error)")
            throw mapFirebaseError(error)
        }
    }
    func resetPassword(email: String) async throws{
        do {
            try await auth.sendPasswordReset(withEmail: email)
        } catch {
            print("❌ Şifre sıfırlama hatası: \(error.localizedDescription)")
            throw mapFirebaseError(error)
        }
    }
    
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResult? {
        let credentials = EmailAuthProvider.credential(withEmail: email, password: password)
        
        do {
            let result = try await authenticateUser(credentials: credentials)
            return result
        } catch {
            print("FirebaseAuthError: signInWithEmail(email:password:) failed. \(error)")
            throw mapFirebaseError(error)
        }
    }
    
    private func mapFirebaseError(_ error: Error) -> NSError {
        let nsError = error as NSError
        
        guard let errorCode = AuthErrorCode(rawValue: nsError.code) else {
            return NSError(domain: "Unkwon", code: 1)
        }
        
        let localizedErrorMessage: String
        print("🔥 Firebase Hata Kodu: \(nsError.code) - Açıklama: \(nsError.localizedDescription)")
        
        switch errorCode {
        case .emailAlreadyInUse:
            localizedErrorMessage = NSLocalizedString("email_already_in_use", comment: "Bu e-posta adresi zaten kullanılıyor.")
        case .invalidEmail:
            localizedErrorMessage = NSLocalizedString("invalid_email", comment: "Geçersiz e-posta adresi.")
        case .weakPassword:
            localizedErrorMessage = NSLocalizedString("weak_password", comment: "Şifreniz çok zayıf. Daha güçlü bir şifre seçin.")
        case .networkError:
            localizedErrorMessage = NSLocalizedString("network_error", comment: "Bağlantı hatası. Lütfen internetinizi kontrol edin.")
        case .userDisabled:
            localizedErrorMessage = NSLocalizedString("user_disabled", comment: "Bu hesap devre dışı bırakılmıştır.")
        case .wrongPassword:
            localizedErrorMessage = NSLocalizedString("wrong_password", comment: "Yanlış şifre girdiniz.")
        case .userNotFound:
            localizedErrorMessage = NSLocalizedString("user_not_found", comment: "Bu e-posta adresine sahip bir hesap bulunamadı.")
        default:
            localizedErrorMessage = NSLocalizedString("unknown_error", comment: "Bilinmeyen bir hata oluştu. Lütfen tekrar deneyin.")
        }
        
        return NSError(domain: nsError.domain, code: nsError.code, userInfo: [NSLocalizedDescriptionKey: localizedErrorMessage])
    }
    
    // 3.Kullanıcı oturum açmışsa mevcut bilgileri bağla
    
    //TODO AYARLAR EKRANINDAN E MAIL ŞİFRE BAĞLANICAK
    private func authLink(credentials: AuthCredential) async throws -> AuthDataResult? {
        do {
            guard let user = auth.currentUser else { return nil }
            let result = try await user.link(with: credentials)
            //await updateDisplayName(for: result.user)
            updateState(user: result.user)
            return result
        }
        catch {
            print("FirebaseAuthError: link(with:) failed, \(error)")
            throw mapFirebaseError(error)
        }
    }
    
    private func updateDisplayName(for user: User) async {
        //apple ya da google sunucudan aldığımız display name ile firebasedekini işliyoruz.
        if let currentDisplayName = auth.currentUser?.displayName, !currentDisplayName.isEmpty {
        } else  {
            let displayName = user.providerData.first?.displayName
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            do {
                try await changeRequest.commitChanges()
            }
            catch {
                print("FirebaseAuthError: Failed to update the user's displayName. \(error.localizedDescription)")
            }
        }
    }
    
    // import GoogleSignIn
    func googleAuth(_ user: GIDGoogleUser) async throws -> AuthDataResult? {
        guard let idToken = user.idToken?.tokenString else { return nil }
        let credentials = GoogleAuthProvider.credential( //googledan gelen bilgileri credential olarak olst.
            withIDToken: idToken,
            accessToken: user.accessToken.tokenString
        )
        do {
            // 2.
            return try await authenticateUser(credentials: credentials)
        }
        catch let error as NSError {
            if error.code == AuthErrorCode.credentialAlreadyInUse.rawValue {
                print("Google hesabı zaten bir kullanıcıya bağlı, giriş yapılıyor...")
                return try await auth.signIn(with: credentials)
            } else {
                print("FirebaseAuthError: googleAuth(user:) failed. \(error.localizedDescription)")
                throw mapFirebaseError(error)
            }
        }
    }
    
    //import AppleSignIn
    func appleAuth(
        _ appleIDCredential: ASAuthorizationAppleIDCredential,
        nonce: String?
    ) async throws -> AuthDataResult? {
        guard let nonce = nonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return nil
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return nil
        }
        
        // 2.
        let credentials = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                        rawNonce: nonce,
                                                        fullName: appleIDCredential.fullName)
        
        do { // 3.
            return try await authenticateUser(credentials: credentials)
        }
        catch {
            print("FirebaseAuthError: appleAuth(appleIDCredential:nonce:) failed. \(error)")
            throw mapFirebaseError(error)
        }
    }
    
    func verifySignInWithAppleID() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let providerData = auth.currentUser?.providerData
        if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
            Task {
                let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
                switch credentialState {
                case .authorized:
                    break // The Apple ID credential is valid.
                case .revoked, .notFound:
                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                    do {
                        try await self.signOut()
                    }
                    catch {
                        print("FirebaseAuthError: signOut() failed. \(error)")
                    }
                default:
                    break
                }
            }
        }
    }
    
    
    func firebaseProviderSignOut(_ user: User) {
        let providers = user.providerData
            .map { $0.providerID }.joined(separator: ", ")
        
        if providers.contains("google.com") {
            GoogleSignInManager.shared.signOutFromGoogle()
        }
    }
    
}

enum AuthState {
    case signedIn
    case signedOut // Not authenticated in Firebase.
}
