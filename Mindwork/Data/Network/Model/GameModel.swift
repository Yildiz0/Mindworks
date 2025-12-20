//
//  GameModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 30.07.2025.
//
import FirebaseFirestore
import SwiftUI

struct GameLocalModel: Identifiable{
    var id = UUID()
    var gameType: GameType
    var title: LocalizedStringKey
    var foregroundColor: Color
    var backgroundColor: Color
}

struct GameQuestion{
    var gameType: GameType
    var questionId: Int
    var questionTitle: LocalizedStringKey
    var questionDescription: LocalizedStringKey
}

struct GameModel{
    @DocumentID var id: String?
    var gameType: GameType
    var relationId: String
}

struct Game{
    @DocumentID var id: String?
    var questionId: Int
    var userOneAnswer: String
    var userOneName: String
    var userTwoAnswer: String?
    var userTwoName: String?
    var date: Timestamp
}

struct StoryGame{
    @DocumentID var id: String?
    var questionId: Int
    var questionText: String?
    var userOneAnswer: String
    var userOneName: String
    var userTwoAnswer: String?
    var userTwoName: String?
    var date: Timestamp
}

struct GameSessionModel: Identifiable, Codable {
    @DocumentID var id: String?
    
    var relationId: String
    var gameType: GameType
    var phase: GamePhase            // answering, review, finished, canceled
    var currentIndex: Int
    
    var questionType: QuestionType?     // sadece question oyunlarında dolu
    var questions: [Int]?               // sadece question oyunlarında dolu
    
    var date: Timestamp
    
    var firstUserName: String
    var firstUserImage: String
    var secondUserName: String
    var secondUserImage: String
}

enum GameType: String, Codable{
    case was_it_there
    case which_different
    case colorful_words
    case catch_pair
    case firefly_title
}

enum StoryType: String, Codable{
    case ancientRome
    case vikings
    case dragons
    case egypt
    case mesopotamia
    case animalsTalk
    case superPower
    case vampire
    case avatar
    case dreams
}
