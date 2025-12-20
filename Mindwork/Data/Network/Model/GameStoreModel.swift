//
//  GameStoreModel.swift
//  Mindwork
//
//  Created by Yakup Kavak on 21.08.2025.
//

import Foundation
import FirebaseFirestore

struct GameStoreModel: Codable {
    @DocumentID var id: String?
    var successRate: Double
    var gameType: GameType
    var date: Timestamp
    var averageTime: Double
}
