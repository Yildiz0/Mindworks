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
    @Published private(set) var elapsedTime: TimeInterval = 0
    @Published private(set) var currentWords: [String] = []
    @Published private(set) var displayedWord: String = ""
    @Published private(set) var lastCorrectCount: Int = 0
    @Published private(set) var feedbackMessage: String = ""
    @Published private(set) var totalCorrect: Int = 0
    @Published private(set) var totalWrong: Int = 0
    @Published private(set) var averageResponseTime: TimeInterval = 0
    
    /// Text fields for user answers (one per word).
    @Published var userInputs: [String] = []
    
    // MARK: - Private Model
    
    private let model = WordCubeGameModel()
    private var failedAttemptsAtMinLevel: Int = 0
    private var currentWordIndex: Int = 0
    private var timerCancellable: AnyCancellable?
    private var timerStartDate: Date?
    private var recallStartDate: Date?
    private var totalResponseTime: TimeInterval = 0
    private var totalWordsAttempted: Int = 0
    
    // Exposed read-only for the view
    var minLevel: Int { model.minLevel }
    var maxLevel: Int { model.maxLevel }
    var wordDisplayDuration: TimeInterval { model.wordDisplayDuration }
    
    // MARK: - Init
    
    init() {
        self.level = model.minLevel
        startTimer()
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
        stopTimer()
    }

    func restartGameTapped() {
        restartGame()
    }
    
    // MARK: - Game Flow
    
    func startNewRound() {
        currentWords = model.generateRandomWords(level: level)
        userInputs = Array(repeating: "", count: level)
        displayedWord = ""
        lastCorrectCount = 0
        feedbackMessage = ""
        currentWordIndex = 0
        recallStartDate = nil
        phase = .idle
    }
    
    private func restartGame() {
        level = model.minLevel
        score = 0
        failedAttemptsAtMinLevel = 0
        totalCorrect = 0
        totalWrong = 0
        totalResponseTime = 0
        totalWordsAttempted = 0
        averageResponseTime = 0
        resetTimer()
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
                    self.recallStartDate = Date()
                }
            }
        }
    }
    
    private func checkAnswers() {
        let responseTime = Date().timeIntervalSince(recallStartDate ?? Date())
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
        let scoreDelta = model.scoreDelta(
            correctCount: result.correctCount,
            wordCount: currentWords.count,
            responseTime: responseTime
        )
        score += scoreDelta
        totalCorrect += result.correctCount
        let wrongCount = max(0, currentWords.count - result.correctCount)
        totalWrong += wrongCount
        totalResponseTime += responseTime
        totalWordsAttempted += currentWords.count
        if totalWordsAttempted > 0 {
            averageResponseTime = totalResponseTime / Double(totalWordsAttempted)
        }
        
        if result.isGameOver {
            phase = .gameOver
            stopTimer()
        } else {
            phase = .result
        }
    }

    var accuracyRate: Double {
        guard totalWordsAttempted > 0 else { return 0 }
        return Double(totalCorrect) / Double(totalWordsAttempted)
    }

    private func startTimer() {
        timerStartDate = Date()
        timerCancellable = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                elapsedTime = Date().timeIntervalSince(timerStartDate ?? Date())
            }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func resetTimer() {
        stopTimer()
        elapsedTime = 0
        startTimer()
    }
}
