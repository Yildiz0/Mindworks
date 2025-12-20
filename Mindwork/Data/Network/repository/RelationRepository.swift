//
//  RelationRepository.swift
//  Tendria
//
//  Created by Yakup Kavak on 29.03.2025.
//

import Foundation
import FirebaseFirestore

class RelationRepository{
    
    private let database = Firestore.firestore()
    static let shared = RelationRepository()
    var relationId: String?
    
    private init(){
    }
    
    func getRelationId() async throws -> String {
        if let cachedRelationId = relationId {
            return cachedRelationId
        }
        if let userId = AuthManager.shared.getUserID(){
            let documentReference = database.collection(FireDatabase.USERS_PATH).document(userId)
            do {
                let document = try await documentReference.getDocument()
                if document.exists {
                    let userRelationId = document.data()?[FireDatabase.RELATION_ID] as? String
                    guard let userRelationId else {
                        throw RelationError.invalidUserRelation
                    }
                    relationId = userRelationId
                    return userRelationId
                }else {
                    throw RelationError.invalidUserRelation
                }
            } catch {
                throw RelationError.invalidUserRelation
            }
        }
        throw RelationError.invalidUserRelation
    }
}
