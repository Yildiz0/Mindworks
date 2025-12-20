//
//  WordCubeGameViewModel.swift
//  WordCube
//
//  Created by Sena Yıldız on 13.11.2025.
//

import SwiftUI
import Combine

/// ViewModel that connects the pure game model with SwiftUI views.
final class WordCubeGameViewModel: ObservableObject {
    
    // MARK: - Published UI State
    
    @Published private(set) var phase: WordCubeGameModel.Phase = .idle
    @Published private(set) var level: Int
    @Published private(set) var score: Int = 0
    @Published private(set) var currentWords: [String] = []
    @Published private(set) var displayedWord: String = ""
    @Published private(set) var lastCorrectCount: Int = 0
    @Published private(set) var feedbackMessage: String = ""
    
    /// Text fields for user answers (one per word).
    @Published var userInputs: [String] = []
    
    // MARK: - Private Model
    
    private let model = WordCubeGameModel()
    private var failedAttemptsAtMinLevel: Int = 0
    private var currentWordIndex: Int = 0
    
    // Exposed read-only for the view
    var minLevel: Int { model.minLevel }
    var maxLevel: Int { model.maxLevel }
    var wordDisplayDuration: TimeInterval { model.wordDisplayDuration }
    
    // MARK: - Init
    
    init() {
        self.level = model.minLevel
        startNewRound()
    }
    
    // MARK: - Intent functions (called from View)
    
    func mainButtonTapped() {
        switch phase {
        case .idle:
            startShowingWords()
        case .showingWords:
            break
        case .recalling:
            checkAnswers()
        case .result:
            break
        case .gameOver:
            restartGame()
        }
    }
    
    func nextRoundTapped() {
        startNewRound()
    }
    
    func endGameTapped() {
        phase = .gameOver
        feedbackMessage = "You chose to end the game at level \(level). Your final score is \(score)."
    }
    
    // MARK: - Game Flow
    
    func startNewRound() {
        currentWords = model.generateRandomWords(count: level)
        userInputs = Array(repeating: "", count: level)
        displayedWord = ""
        lastCorrectCount = 0
        feedbackMessage = ""
        currentWordIndex = 0
        phase = .idle
    }
    
    private func restartGame() {
        level = model.minLevel
        score = 0
        failedAttemptsAtMinLevel = 0
        startNewRound()
    }
    
    private func startShowingWords() {
        phase = .showingWords
        currentWordIndex = 0
        displayedWord = ""
        showNextWord()
    }
    
    private func showNextWord() {
        guard phase == .showingWords else { return }
        
        if currentWordIndex < currentWords.count {
            displayedWord = currentWords[currentWordIndex]
            currentWordIndex += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + model.wordDisplayDuration) { [weak self] in
                self?.showNextWord()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                guard let self else { return }
                if self.phase == .showingWords {
                    self.displayedWord = ""
                    self.phase = .recalling
                }
            }
        }
    }
    
    private func checkAnswers() {
        let result = model.evaluateRound(
            expected: currentWords,
            userInputs: userInputs,
            currentLevel: level,
            failedAttemptsAtMinLevel: failedAttemptsAtMinLevel
        )
        
        lastCorrectCount = result.correctCount
        level = result.newLevel
        failedAttemptsAtMinLevel = result.newFailedAttemptsAtMinLevel
        feedbackMessage = result.feedbackMessage
        score += result.scoreDelta
        
        if result.isGameOver {
            phase = .gameOver
        } else {
            phase = .result
        }
    }
}
