//
//  FirestoreManager.swift
//  Tendria
//
//  Created by Yakup Kavak on 10.02.2025.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFunctions
import FirebaseMessaging

class FirestorageManager {
    
    static let shared = FirestorageManager()
    private let storage = Storage.storage()
    private let functions = Functions.functions()
    private let database = Firestore.firestore()
    let storageRef: StorageReference
    let memoryRef: StorageReference
    let collectionRef: StorageReference
    let profileImageRef: StorageReference
    
    private init() {
        self.storageRef = storage.reference()
        self.memoryRef = storageRef.child(FireStorage.MEMORY_PATH)
        self.collectionRef = storageRef.child(FireStorage.COLLECTION_PATH)
        self.profileImageRef = storageRef.child(FireStorage.PROFILE_IMAGE_PATH)
    }
    
    func addCollectionImage(imageData: Data) async throws -> String {
        let uniqueFileName = UUID().uuidString + ".jpg"
        let listImageRef = collectionRef.child("\(uniqueFileName)")
        
        do {
            let uploadTask = try await listImageRef.putDataAsync(imageData){ progress in
                print("Upload progress: \(progress?.fractionCompleted ?? 0)")
            }
            let uploadUrl = try await listImageRef.downloadURL()
            print("Upload successful, metadata: \(uploadTask)")
            return uploadUrl.absoluteString
        }
        catch {
            print("Upload failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func addMemoryImages(imageDatas: [Data]) async throws -> [String] {
        return try await withThrowingTaskGroup(of: String.self) { group in
            for image in imageDatas {
                group.addTask {
                    let uniqueFileName = UUID().uuidString + ".jpg"
                    let listImageRef = self.memoryRef.child("\(uniqueFileName)")
                    let uploadTask = try await listImageRef.putDataAsync(image){ progress in
                        print("Upload progress: \(progress?.fractionCompleted ?? 0)")
                    }
                    let uploadUrl = try await listImageRef.downloadURL()
                    print("Upload successful, metadata: \(uploadTask)")
                    return uploadUrl.absoluteString
                }
            }
            var returnList = [String]()
            
            for try await imageUrl in group {
                returnList.append(imageUrl)
            }
            
            return returnList
        }
    }
    
    func addMemoryDocument(memoryDocumentModel: MemoryDocumentModel) async throws{
        let newListRef = database.collection(FireDatabase.MEMORY_PATH).document()
        try await addDocument(documentRef: newListRef, value: memoryDocumentModel)
    }
    
    func addCollectionDocument(collectionDocumentModel: CollectionDocumentModel) async throws{
        let newListRef = database.collection(FireDatabase.COLLECTION_PATH).document()
        try await addDocument(documentRef: newListRef, value: collectionDocumentModel)
    }

    private func addDocument<T: Encodable>(documentRef: DocumentReference, value: T) async throws {
        do {
            try documentRef.setData(from: value)
            print("Document added successfully")
        } catch {
            print("Failed to add document: \(error.localizedDescription)")
            throw error
        }
    }
    
    func generateConnectionCode() async throws -> String?{
        let randomCode = randomString(length: Numbers.RANDOM_COUNT)
        let relationCodeRef = database.collection(FireDatabase.RELATION_CODE_PATH).document()
        guard let currentUserId = AuthManager.shared.getUserID() else {
            return nil
        }
        let newDocument = RelationCodeModel(firstUserId: currentUserId, secondUserId: nil, relationCode: randomCode, createDate: Timestamp(date: Date()))
        try await addDocument(documentRef: relationCodeRef, value: newDocument)
        return randomCode
    }
    
    func checkAndAddRelation(relationCode: String) async throws -> String {
        let data = ["relationCode": relationCode]
        do {
            let result = try await functions.httpsCallable(FunctionName.CHECK_AND_ADD_RELATION).call(data)
            if let response = result.data as? [String: Any],
               let relationshipId = response["relationshipId"] as? String {
                return relationshipId
            } else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No relationship ID found."])
            }
        } catch let error as NSError {
            if let firebaseError = error.userInfo[FunctionsErrorDetailsKey] as? [String: Any],
               let message = firebaseError["message"] as? String {
                print("Cloud Function Error: \(message)")
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: message])
            } else {
                print("Error calling function: \(error.localizedDescription)")
                throw error
            }
        }
    }
    
    func saveGame(gameData: GameStoreModel) async throws {
        guard let userId = AuthManager.shared.getUserID() else { return }
        
        let eventReference = database.collection(FireDatabase.USERS_PATH).document(userId).collection("games").document()
        try await addDocument(documentRef: eventReference, value: gameData)
    }
    
    func configureFcmToken(){
        guard let userMail = AuthManager.shared.getUserMail() else { return }
        
        Messaging.messaging().token(){token,error in
            if let fcmToken = token{
                let userKey = userMail + KeychainKeys.FCM_TOKEN
                let storedToken = KeychainHelper.shared.getToken(key: userKey)
                if(storedToken == fcmToken){
                    print("key aynı kaydedilmedi")
                }else{
                    let userKey = userMail + KeychainKeys.FCM_TOKEN
                    KeychainHelper.shared.saveToken(fcmToken, key: userKey)
                    self.saveTokenToFirestore(token: fcmToken)
                    print("key kaydedildi")
                }
            }
            if let error = error{
                print("error ->", error.localizedDescription)
            }
        }
    }
    
    func configureUserLanguage(userID: String,preferLanguage: String? = nil){
        guard let preferLanguage = preferLanguage else {
            //DEFAULT USERS LANGUAGE
            let userLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            setDataToUser(data: userLanguage, path: FireDatabase.USER_LANGUAGE)
            return
        }
        setDataToUser(data: preferLanguage, path: FireDatabase.USER_LANGUAGE)
    }
    
    func saveTokenToFirestore(token: String) {
        setDataToUser(data: token,path: FireDatabase.FCM_TOKEN_FIELD)
    }
    
    private func setDataToUser(data: String, path: String){
        guard let userID = AuthManager.shared.getUserID() else {
            print("No user is logged in. Token not saved.")
            return
        }
        let userRef = database.collection(FireDatabase.USERS_PATH).document(userID)
        userRef.setData([path: data], merge: true) { error in
            if let error = error {
                print("Error saving data to Firestore: \(error.localizedDescription)")
            } else {
                print("\(data) successfully saved to Firestore!")
            }
        }
    }
    
    func checkUserRelation() async throws -> Bool {
        guard let userId = AuthManager.shared.getUserID() else {
            return false
        }
        let documentReference = database.collection(FireDatabase.USERS_PATH).document(userId)
        
        do {
            let document = try await documentReference.getDocument()
            if document.exists {
                let relationId = document.data()?[FireDatabase.RELATION_ID] as? String
                return !(relationId?.isEmpty ?? true)
            }else {
                return false
            }
        } catch {
            throw error
        }
    }
    
    func fetchCollectionList() async throws -> IsCollectionExist {
        let relationId = try await RelationRepository.shared.getRelationId()
        let documentReference = database.collection(FireDatabase.COLLECTION_PATH)
        do {
            let querySnapshot = try await documentReference.whereField(FireDatabase.RELATION_ID, isEqualTo: relationId).getDocuments()
            if(querySnapshot.documents.count == 0){
                return IsCollectionExist.nonExist
            }
            var documentList: [CollectionDocumentModel] = []
            for document in querySnapshot.documents{
                let data = try document.data(as: CollectionDocumentModel.self)
                let collectionModel = CollectionDocumentModel(id: data.id, imageUrl: data.imageUrl, title: data.title, relationId: data.relationId, description: data.description, createDate: data.createDate)
                documentList.append(collectionModel)
            }
            return IsCollectionExist.exist(documentList)
        }catch {
            throw error
        }
    }
    
    func fetchMemoryList(collectionId: String) async throws -> FetchDataList<MemoryDocumentModel> {
        let documentReference = database.collection(FireDatabase.MEMORY_PATH)
        do {
            let querySnapshot = try await documentReference.whereField(FireDatabase.COLLECTION_ID, isEqualTo: collectionId).getDocuments()
            if(querySnapshot.documents.count == 0){
                return FetchDataList.nonExist
            }
            var documentList: [MemoryDocumentModel] = []
            for document in querySnapshot.documents{
                let data = try document.data(as: MemoryDocumentModel.self)
                let memoryModel = MemoryDocumentModel(collectionId: data.collectionId, imageUrls: data.imageUrls, relationId: data.relationId, title: data.title, userOneDescription: data.userOneDescription, userTwoDescription: data.userTwoDescription, userOneImage: data.userOneImage, userTwoImage: data.userTwoImage, createDate: data.createDate)
                documentList.append(memoryModel)
            }
            return FetchDataList.exist(documentList)
        }catch {
            throw error
        }
    }
    
    func fetchUserRelationship(relationId: String) async throws -> RelationshipModel {
        let documentReference = database.collection(FireDatabase.RELATIONSHIP_PATH)
        
        do {
            let documentSnapshot = try await documentReference.document(relationId).getDocument()
            
            guard let document = try? documentSnapshot.data(as: RelationshipModel.self) else {
                throw RelationError.invalidUserRelation
            }
            return document
        } catch {
            throw error
        }
    }
    
    func saveEvent(title: String, description: String, date: Date, startHour: Date, endHour: Date, tenMinuteNotification: Bool, category: CategoryModel?,location: String,profileImage: String?, name: String) async throws{
        let relationId = try await RelationRepository.shared.getRelationId()
        let newDocument = EventDocumentModel(relationId: relationId, title: title, comment: description, eventDate: Timestamp(date: date), startHour: Timestamp(date: startHour), finishHour: Timestamp(date: endHour), location: location, category: category, isRemind: tenMinuteNotification, createrProfileImage: profileImage, createrName: name)
        let eventReference = database.collection(FireDatabase.EVENT_PATH).document()
        try await addDocument(documentRef: eventReference, value: newDocument)
    }
    
    func listenEvents(
        relationId: String,
        onChange: @escaping @Sendable ([EventDocumentModel]) async -> Void
    ) -> ListenerRegistration {
        database.collection(FireDatabase.EVENT_PATH)
            .whereField(FireDatabase.RELATION_ID, isEqualTo: relationId)
            .addSnapshotListener { snap, _ in
                guard let docs = snap?.documents else { return }
                let list = docs.compactMap { try? $0.data(as: EventDocumentModel.self) }
                Task {
                    await onChange(list)
                }
            }
    }
    
    func deleteEvent(_ ev: EventDocumentModel) async throws {
        guard let id = ev.id else { return }
        try await database.collection(FireDatabase.EVENT_PATH).document(id).delete()
    }
    
    func updateProfileImage(imageData: Data) async throws -> String {
        guard let userId = AuthManager.shared.getUserID() else {
            throw RelationError.invalidUserId
        }
        
        // ▶︎ Dosya yolu: userProfileImages/{userId}.jpg
        let ref = profileImageRef.child("\(userId).jpg")
        
        // Eski dosyayı sil (varsa hata yutulabilir)
        try? await ref.delete()
        
        // Yeni resmi yükle
        _ = try await ref.putDataAsync(imageData)
        
        // İmzalı download URL’si
        let url = try await ref.downloadURL().absoluteString
        
        // Firestore’a yaz
        try await database.collection(FireDatabase.USERS_PATH)
            .document(userId)
            .updateData([FireDatabase.USER_PROFILE_IMAGE: url])
        
        return url
    }
    
    func deleteImageAtURL(urlString: String) async throws {
        let ref = storage.reference(forURL: urlString)
        do {
            try await ref.delete()
        } catch{
            print("Eski foto bulunamadı, devam ediliyor")
        }
    }
    
    func fetchProfile() async throws -> UserModel {
        guard let userId = AuthManager.shared.getUserID() else {
            throw RelationError.invalidUserId
        }
        let userRef = database.collection(FireDatabase.USERS_PATH)
            .document(userId)
        
        let document = try await userRef.getDocument()
        
        guard let data = document.data() else {
            throw RelationError.unknown
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        let user = try JSONDecoder().decode(UserModel.self, from: jsonData)
        
        return user
    }
    
    func fetchProfileScores() async throws -> [GameStoreModel] {
        guard let userId = AuthManager.shared.getUserID() else {
            throw RelationError.invalidUserId
        }
        let userRef = database.collection(FireDatabase.USERS_PATH)
            .document(userId).collection("games")
        
        let snap = try await userRef.order(by: "date", descending: true)
            .getDocuments()
        
        return try snap.documents.map { try $0.data(as: GameStoreModel.self) }
    }
    
    func updateProfile(name: String, surname: String, email: String?, phoneNumber: String?) async throws {
        guard let userId = AuthManager.shared.getUserID() else {
            throw RelationError.invalidUserId
        }
        let userRef = database.collection(FireDatabase.USERS_PATH)
        .document(userId)
        var updatedData: [String: Any] = [
            FireDatabase.USER_NAME: name,
            FireDatabase.USER_SURNAME: surname
        ]
        
        if let email = email {
            updatedData[FireDatabase.USER_EMAIL] = email
        }
        
        if let phoneNumber = phoneNumber {
            updatedData[FireDatabase.USER_PHONE] = phoneNumber
        }
        updatedData["fcmToken"] = "todo"
        
        try await userRef.updateData(updatedData)
    }
    @MainActor
    func checkAndCreateAnyGameSession(
        relationId:     String,
        newGameType:    GameType,          // .question, .memoryMatch …
        questionType:   QuestionType?,     // sadece question için dolu
        firstName:      String,
        firstImage:     String,
        secondName:     String,
        secondImage:    String
    ) async -> GameExist {
        
        let gamesRef = Firestore.firestore()
            .collection("Relationship")
            .document(relationId)
            .collection("games")
        
        do {
            // 1️⃣ İlişkide bitmemiş HERHANGİ oyun?
            let query = gamesRef
                .whereField("phase", isNotEqualTo: GamePhase.finished.rawValue)
                .whereField("phase", isNotEqualTo: GamePhase.canceled.rawValue)
                .limit(to: 1)
                .order(by: "phase")      // Firestore kuralı
                .order(by: "date")
            
            if let doc = try await query.getDocuments().documents.first,
               let active = try? doc.data(as: GameSessionModel.self) {
                return .existing(active)           // ↩️ devam et/iptal sorusu
            }
            
            // 2️⃣ Yeni oturum hazırla
            let date = Timestamp(date: Date())
            var session = GameSessionModel(
                id: nil,
                relationId: relationId,
                gameType:   newGameType,
                phase:      .answering,
                currentIndex: 0,
                questionType:  questionType,
                questions:     questionType != nil ? Array(0..<10).shuffled() : nil,
                date:       date,
                firstUserName:  firstName,
                firstUserImage: firstImage,
                secondUserName: secondName,
                secondUserImage: secondImage
            )
            
            let docRef = gamesRef.document()
            session.id = docRef.documentID
            try docRef.setData(from: session)
            return .created(session)
        }
        catch {
            return .failure(error)
        }
    }
}
