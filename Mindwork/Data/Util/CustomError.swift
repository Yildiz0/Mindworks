//
//  CustomError.swift
//  Tendria
//
//  Created by Yakup Kavak on 19.02.2025.
//

import Foundation

enum RelationError: LocalizedError {
    case duplicateCode // Aynı kod oluştu hatası
    case unknown // Bilinmeyen hata
    case invalidUserId
    case invalidUserRelation
    
    var errorDescription: String? {
        switch self {
        case .duplicateCode:
            return NSLocalizedString("duplicate_code_error", comment: "Duplicate relation code found. Please generate a new one.")
        case .unknown:
            return NSLocalizedString("unknown_error", comment: "An unknown error occurred. Please try again.")
        case .invalidUserId:
            return NSLocalizedString("invalid_user_id", comment: "User ID not found. Please check and try again.")
        case .invalidUserRelation:
            return NSLocalizedString("invalid_relation_id", comment: "Relation ID not found. Please check and try again.")
        }
    }
}
