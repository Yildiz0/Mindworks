//
//  GameModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 29.07.2025.
//

import FirebaseFirestore
import SwiftUI

struct QuestionLocalModel: Identifiable{
    var id = UUID()
    var questionType: QuestionType
    var title: LocalizedStringKey
    var foregroundColor: Color
    var backgroundColor: Color
}

struct LocalQuestion{
    var gameType: QuestionType
    var questionId: Int
    var questionTitle: LocalizedStringKey
    var questionDescription: LocalizedStringKey
}

struct QuestionModel{
    @DocumentID var id: String?
    var gameType: QuestionType
    var relationId: String
}

struct Question{
    @DocumentID var id: String?
    var questionId: Int
    var userOneAnswer: String
    var userOneName: String
    var userTwoAnswer: String?
    var userTwoName: String?
    var date: Timestamp
}

enum QuestionType: String, Codable{
    case was_it_there
    case which_different
    case colorful_words
    case catch_pair
    case firefly_title
    case reflexGame
    case wordCube
    case timing
}
