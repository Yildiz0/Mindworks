//
//  WordCubeGameModel.swift
//  WordCube
//
//  Created by Sena Yıldız on 13.11.2025.
//

import Foundation

/// Pure model that contains the game rules and data helpers for Word Cube.
struct WordCubeGameModel {
    
    // MARK: - Constants (game configuration)
    
    let minLevel = 3
    let maxLevel = 15
    let wordDisplayDuration: TimeInterval = 1.2
    
    /// Word pool used to generate sequences.
    let wordPool: [String] = [
        "apple", "table", "ocean", "pencil", "cloud", "road",
        "cat", "book", "door", "tree", "light", "bag",
        "car", "garden", "city", "window", "chair",
        "sun", "moon", "leaf", "question", "answer", "time",
        "color", "game", "bird", "fish", "flower", "mountain"
    ]
    
    // MARK: - Types
    
    /// Game phases from the business-logic point of view.
    enum Phase {
        case idle
        case showingWords
        case recalling
        case result
        case gameOver
    }
    
    /// Result of evaluating one round.
    struct EvaluationResult {
        let correctCount: Int
        let newLevel: Int
        let newFailedAttemptsAtMinLevel: Int
        let feedbackMessage: String
        let isGameOver: Bool
        let scoreDelta: Int
    }
    
    // MARK: - Logic Helpers (pure functions)
    
    /// Generates a random sequence of words of given length.
    func generateRandomWords(count: Int) -> [String] {
        var pool = wordPool.shuffled()
        var result: [String] = []
        
        for _ in 0..<count {
            if pool.isEmpty {
                pool = wordPool.shuffled()
            }
            result.append(pool.removeFirst())
        }
        return result
    }
    
    /// Evaluates user's answers and returns how the game state should change.
    ///
    /// - Parameters:
    ///   - expected: Words shown in order.
    ///   - userInputs: User's answers in order.
    ///   - currentLevel: Current level before evaluation.
    ///   - failedAttemptsAtMinLevel: How many times level 3 failed consecutively.
    ///
    /// - Returns: `EvaluationResult` describing new level, score delta, etc.
    func evaluateRound(expected: [String],
                       userInputs: [String],
                       currentLevel: Int,
                       failedAttemptsAtMinLevel: Int) -> EvaluationResult {
        
        let correct = zip(expected, userInputs).reduce(0) { partial, pair in
            let (exp, input) = pair
            let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            return partial + (trimmed == exp.lowercased() ? 1 : 0)
        }
        
        var level = currentLevel
        var failedMin = failedAttemptsAtMinLevel
        var feedback = ""
        var isGameOver = false
        var scoreDelta = correct           // 1 point per correct word
        
        // Special rule for first level (level = 3)
        if level == minLevel {
            if correct == level {
                failedMin = 0
            } else {
                failedMin += 1
            }
            
            if failedMin >= 2 {
                feedback = "You could not complete the first level two times in a row."
                isGameOver = true
                // Score delta already added: correct answers from this round
                return EvaluationResult(
                    correctCount: correct,
                    newLevel: level,
                    newFailedAttemptsAtMinLevel: failedMin,
                    feedbackMessage: feedback,
                    isGameOver: isGameOver,
                    scoreDelta: scoreDelta
                )
            }
        }
        
        // General level up/down rules
        if correct == level {
            feedback = "Great job! You remembered all the words correctly. Level up! 🎉"
            if level < maxLevel { level += 1 }
        } else if correct * 2 < level { // less than half correct
            if level > minLevel {
                level -= 1
                feedback = "You remembered \(correct) words. You move down one level. Keep trying! 💪"
            } else {
                feedback = "You remembered \(correct) words. Try the same level again. 🙂"
            }
        } else {
            feedback = "Not bad! You remembered \(correct) words. Try this level again. 🙂"
        }
        
        if level > minLevel {
            failedMin = 0
        }
        
        return EvaluationResult(
            correctCount: correct,
            newLevel: level,
            newFailedAttemptsAtMinLevel: failedMin,
            feedbackMessage: feedback,
            isGameOver: isGameOver,
            scoreDelta: scoreDelta
        )
    }
}
