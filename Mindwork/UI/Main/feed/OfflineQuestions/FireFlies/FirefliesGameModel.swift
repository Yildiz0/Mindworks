//
//  FirefliesGameModel.swift
//  Fireflies
//
//  Created by Sena Yıldız on 14.11.2025.
//
import Foundation

/// Pure model that contains the game rules and helper functions for Fireflies.
struct FirefliesGameModel {
    
    // MARK: - Game Configuration
    
    let minLevel = 3
    let maxLevel = 8
    let fireflyCount = 8
    let lightDuration: TimeInterval = 0.7
    let pauseDuration: TimeInterval = 0.3
    
    // MARK: - Phase
    
    enum Phase {
        case idle            // waiting to start sequence
        case showingSequence // sequence is being shown
        case waitingForInput // user tapping fireflies
        case result          // round result
        case gameOver        // game finished (End Game)
    }
    
    // MARK: - Evaluation Result
    
    struct EvaluationResult {
        let newLevel: Int
        let feedbackMessage: String
        let lastRoundCorrect: Bool
        let shouldFinishRound: Bool   // true -> go to result, false -> second attempt
        let scoreDelta: Int           // points gained in this attempt
    }
    
    // MARK: - Helpers (pure functions)
    
    /// Generate a random sequence of firefly indices.
    func generateSequence(length: Int, level: Int) -> [Int] {
        var sequence: [Int] = []
        let preventDouble = level <= (minLevel + 1)
        
        for _ in 0..<length {
            var next = Int.random(in: 0..<fireflyCount)
            
            if preventDouble {
                while next == sequence.last {
                    next = Int.random(in: 0..<fireflyCount)
                }
            } else if sequence.count >= 2,
                      let last = sequence.last,
                      last == sequence[sequence.count - 2] {
                while next == last {
                    next = Int.random(in: 0..<fireflyCount)
                }
            }
            
            sequence.append(next)
        }
        
        return sequence
    }
    
    /// Evaluate one attempt for the current round.
    ///
    /// - Parameters:
    ///   - sequence: The correct sequence.
    ///   - userSequence: What user tapped.
    ///   - currentLevel: Level before evaluation.
    ///   - attemptsUsed: Number of attempts already used (0 or 1).
    ///
    /// - Returns: `EvaluationResult` describing new level, score change and whether the round ends.
    func evaluateAttempt(sequence: [Int],
                         userSequence: [Int],
                         currentLevel: Int,
                         attemptsUsed: Int) -> EvaluationResult {
        
        let isCorrect = (sequence == userSequence)
        var newLevel = currentLevel
        var feedback = ""
        var lastCorrect = false
        var shouldFinish = false
        var scoreDelta = 0
        
        if isCorrect {
            lastCorrect = true
            shouldFinish = true
            
            if attemptsUsed == 0 {
                // First attempt success
                feedback = "Great job! You followed the sequence correctly on your first try. 🎉"
                scoreDelta = currentLevel * 2
            } else {
                // Second attempt success
                feedback = "Nice! You got it right on your second attempt. 🎉"
                scoreDelta = currentLevel
            }
            
            // Level up if possible
            if newLevel < maxLevel {
                newLevel += 1
            }
        } else {
            // Wrong answer
            lastCorrect = false
            
            if attemptsUsed == 0 {
                // First wrong attempt -> one more chance
                feedback = "That was not the correct order. You have one more attempt with the same sequence."
                shouldFinish = false
            } else {
                // Second wrong attempt -> end round, maybe level down
                shouldFinish = true
                if newLevel > minLevel {
                    newLevel -= 1
                    feedback = "Both attempts were incorrect. You move down one level. Keep trying! 💪"
                } else {
                    feedback = "Both attempts were incorrect. You stay at the same level. Try again! 💪"
                }
            }
        }
        
        return EvaluationResult(
            newLevel: newLevel,
            feedbackMessage: feedback,
            lastRoundCorrect: lastCorrect,
            shouldFinishRound: shouldFinish,
            scoreDelta: scoreDelta
        )
    }
}
