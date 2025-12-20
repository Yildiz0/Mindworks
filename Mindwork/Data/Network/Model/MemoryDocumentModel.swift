//
//  Untitled.swift
//  Tendria
//
//  Created by Yakup Kavak on 2.04.2025.
//

import FirebaseCore
import FirebaseFirestore

struct MemoryDocumentModel: Identifiable,Codable,Equatable,Hashable{
    @DocumentID var id: String?
    let collectionId: String
    let imageUrls: [String]
    let relationId: String
    let title: String
    let userOneDescription: String?
    let userTwoDescription: String?
    let userOneImage: String?
    let userTwoImage: String?
    let createDate: Timestamp

  enum CodingKeys: String, CodingKey {
    case id
    case collectionId
    case imageUrls
    case title
    case relationId
    case userOneDescription
    case userTwoDescription
    case userOneImage
    case userTwoImage
    case createDate
  }
}

enum FetchDataList<T> {
    case exist([T])
    case nonExist
    
    private var caseName: String {
        switch self {
        case .exist: return "exist"
        case .nonExist: return "nonExist"
        }
    }
    
    func hasSameCase(as type: Self) -> Bool {
        return self.caseName == type.caseName
    }
}
