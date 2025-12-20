//
//  RelationshipModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 26.02.2025.
//

import Foundation
import FirebaseCore

public struct RelationshipModel: Codable {
    
    let firstUserId: String
    let firstUserName: String
    let firstUserImageUrl: String
    let secondUserId: String?
    let secondUserName: String?
    let secondUserImageUrl: String?
    let createDate: Timestamp
    
    enum CodingKeys: String, CodingKey {
        case firstUserId
        case firstUserName
        case firstUserImageUrl
        case secondUserId
        case secondUserName
        case secondUserImageUrl
        case createDate
    }
}
