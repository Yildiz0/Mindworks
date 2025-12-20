//
//  TaskRowModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 4.02.2025.
//

import Foundation
import FirebaseFirestore

struct CollectionDocumentModel: Identifiable,Codable,Equatable,Hashable{
    @DocumentID var id: String?
    var imageUrl: String
    var title: String
    var relationId: String
    var description: String
    let createDate: Timestamp
    
    enum CodingKeys: String, CodingKey {
      case id
      case imageUrl
      case title
      case relationId
      case description
      case createDate
    }
}

enum IsCollectionExist {
    case exist([CollectionDocumentModel])
    case nonExist
    case noneRelation
    
    private var caseName: String {
        switch self {
        case .exist: return "exist"
        case .nonExist: return "nonExist"
        case .noneRelation: return "noneRelation"
        }
    }
    
    func hasSameCase(as type: Self) -> Bool {
        return self.caseName == type.caseName
    }
}
