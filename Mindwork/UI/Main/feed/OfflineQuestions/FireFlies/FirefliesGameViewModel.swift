//
//  FirefliesGameViewModel.swift
//  Fireflies
//
//  Created by Sena Yıldız on 14.11.2025.
//

import SwiftUI
import Combine

/// ViewModel that connects the FirefliesGameModel with SwiftUI views.
final class FirefliesGameViewModel: ObservableObject {
    
    // MARK: - Published State for the View
    
    @Published private(set) var phase: FirefliesGameModel.Phase = .idle
    @Published private(set) var level: Int
    @Published private(set) var maxLevelReached: Int
    @Published private(set) var score: Int = 0
    
    @Published private(set) var sequence: [Int] = []
    @Published private(set) var userSequence: [Int] = []
    @Published private(set) var highlightedIndex: Int? = nil
    
    @Published private(set) var feedbackMessage: String = ""
    @Published private(set) var lastRoundCorrect: Bool = false
    @Published private(set) var attemptsThisRound: Int = 0   // 0 or 1
    
    // MARK: - Private Model
    
    private let model = FirefliesGameModel()
    
    // Expose some model configuration for the View
    var minLevel: Int { model.minLevel }
    var maxLevel: Int { model.maxLevel }
    var fireflyCount: Int { model.fireflyCount }
    var lightDuration: TimeInterval { model.lightDuration }
    var pauseDuration: TimeInterval { model.pauseDuration }
    
    // MARK: - Init
    
    init() {
        self.level = model.minLevel
        self.maxLevelReached = model.minLevel
        startNewRound()
    }
    
    // MARK: - Intent Functions (called from the View)
    
    func mainButtonTapped() {
        switch phase {
        case .idle:
            startShowingSequence()
        case .showingSequence:
            break
        case .waitingForInput:
            if userSequence.count == sequence.count {
                checkAttempt()
            }
        case .result:
            break
        case .gameOver:
            restartGame()
        }
    }
    
    func fireflyTapped(index: Int) {
        guard phase == .waitingForInput else { return }
        guard userSequence.count < sequence.count else { return }
        userSequence.append(index)
    }
    
    func nextRoundTapped() {
        startNewRound()
    }
    
    func endGameTapped() {
        phase = .gameOver
        feedbackMessage = "You ended the game at level \(level).\nHighest level reached: \(maxLevelReached).\nYour final score is \(score)."
    }
    
    // MARK: - Game Flow
    
    func startNewRound() {
        sequence = model.generateSequence(length: level)
        userSequence = []
        highlightedIndex = nil
        feedbackMessage = ""
        lastRoundCorrect = false
        attemptsThisRound = 0
        phase = .idle
    }
    
    private func restartGame() {
        level = model.minLevel
        maxLevelReached = model.minLevel
        score = 0
        sequence = []
        userSequence = []
        highlightedIndex = nil
        feedbackMessage = ""
        lastRoundCorrect = false
        attemptsThisRound = 0
        phase = .idle
        startNewRound()
    }
    
    private func startShowingSequence() {
        phase = .showingSequence
        userSequence = []
        attemptsThisRound = 0
        lastRoundCorrect = false
        showSequenceStep(at: 0)
    }
    
    private func showSequenceStep(at index: Int) {
        guard phase == .showingSequence else { return }
        
        if index < sequence.count {
            highlightedIndex = sequence[index]
            
            DispatchQueue.main.asyncAfter(deadline: .now() + model.lightDuration) { [weak self] in
                guard let self else { return }
                self.highlightedIndex = nil
                DispatchQueue.main.asyncAfter(deadline: .now() + self.model.pauseDuration) {
                    self.showSequenceStep(at: index + 1)
                }
            }
        } else {
            // Finished showing
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                guard let self else { return }
                self.highlightedIndex = nil
                self.phase = .waitingForInput
            }
        }
    }
    
    private func checkAttempt() {
        let result = model.evaluateAttempt(
            sequence: sequence,
            userSequence: userSequence,
            currentLevel: level,
            attemptsUsed: attemptsThisRound
        )
        
        // Apply result
        level = result.newLevel
        feedbackMessage = result.feedbackMessage
        lastRoundCorrect = result.lastRoundCorrect
        score += result.scoreDelta
        
        // Track highest level reached
        maxLevelReached = max(maxLevelReached, level)
        
        if result.shouldFinishRound {
            // Round is over
            attemptsThisRound = 0
            phase = .result
        } else {
            // One more attempt for same round
            attemptsThisRound += 1
            userSequence = []
            // phase stays in .waitingForInput
        }
    }
}
