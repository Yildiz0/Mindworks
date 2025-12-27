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
    let idealTimePerWord: TimeInterval = 5
    
    /// Word pools grouped by length to scale difficulty.
    private let shortWords: [String] = [
        "cat", "dog", "sun", "moon", "tree", "road", "book", "door", "fish", "bird",
        "leaf", "rain", "wind", "star", "lamp", "milk", "cake", "lion", "bear", "frog",
        "ship", "ball", "desk", "shoe", "game", "hand", "ring", "gold", "blue", "pink",
        "snow", "rock", "sand", "fire", "wave", "note", "sock", "mask", "root", "lake"
    ]

    private let mediumWords: [String] = [
        "apple", "table", "ocean", "pencil", "cloud", "chair", "light", "smile", "dream", "brush",
        "river", "cabin", "stone", "bread", "green", "flame", "radio", "crown", "honey", "music",
        "earth", "glass", "train", "party", "sugar", "tiger", "camel", "grape", "sound", "watch"
    ]

    private let longWords: [String] = [
        "garden", "window", "planet", "silver", "hunter", "magnet", "bridge", "summer", "forest", "orange",
        "yellow", "market", "school", "rabbit", "sailor", "camera", "castle", "pocket", "flower", "throne",
        "travel", "mirror", "tunnel", "ticket", "winter", "beacon", "bottle", "glider", "canyon", "voyage"
    ]

    private let longerWords: [String] = [
        "mountain", "question", "answering", "building", "painting", "sunlight", "notebook", "happiness",
        "language", "football", "cheerful", "treasure", "umbrella", "chocolate", "adventure", "triangle",
        "merchant", "ceremony", "backpack", "waterfall", "sandwich", "dangerous", "beautiful", "butterfly"
    ]

    private let longestWords: [String] = [
        "electricity", "photograph", "celebration", "microphone", "helicopter", "temperature", "revolution",
        "friendship", "imagination", "comfortable", "responsible", "conversation", "environment", "playground",
        "basketball", "application", "volunteer", "association", "extraordinary", "constellation"
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
    
    /// Generates a random sequence of words of given length, scaling word length by level.
    func generateRandomWords(level: Int) -> [String] {
        let pool = poolForLevel(level).shuffled()
        let targetCount = level
        var workingPool = pool
        var result: [String] = []
        
        for _ in 0..<targetCount {
            if workingPool.isEmpty {
                workingPool = poolForLevel(level).shuffled()
            }
            result.append(workingPool.removeFirst())
        }
        return result
    }

    /// Calculates score delta based on correct answers and response time.
    func scoreDelta(correctCount: Int, wordCount: Int, responseTime: TimeInterval) -> Int {
        let baseScore = correctCount * 10
        let bonus = speedBonus(wordCount: wordCount, responseTime: responseTime)
        return baseScore + bonus
    }

    func speedBonus(wordCount: Int, responseTime: TimeInterval) -> Int {
        let idealTime = Double(wordCount) * idealTimePerWord
        guard responseTime > 0, responseTime < idealTime else { return 0 }
        let ratio = (idealTime - responseTime) / idealTime
        let rawBonus = Int((ratio * 10).rounded(.toNearestOrAwayFromZero))
        return min(10, max(0, rawBonus))
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
        let scoreDelta = 0
        
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

    private func poolForLevel(_ level: Int) -> [String] {
        switch level {
        case minLevel...4:
            return shortWords
        case 5...6:
            return mediumWords
        case 7...8:
            return longWords
        case 9...11:
            return longerWords
        default:
            return longestWords
        }
    }
}
