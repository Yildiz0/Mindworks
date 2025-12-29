//
//  ReverseWordViewModel.swift
//  ReverseWord
//
//  Created by Sena Yıldız on 21.12.2025.
//

import Combine
import Foundation
import SwiftUI

final class ReverseWordViewModel: ObservableObject {

    enum Phase {
        case ready
        case showingWord
        case typing
        case feedback
        case gameOver
    }

    // MARK: - Published (UI State)
    @Published var phase: Phase = .ready

    @Published var currentWord: String = ""
    @Published var isWordHidden: Bool = false
    @Published var userInput: String = ""

    @Published var levelLength: Int = 3
    @Published var score: Int = 0

    @Published var feedbackText: String = ""
    @Published var feedbackColor: Color = .green

    @Published var lastRoundPoints: Int? = nil

    // ✅ Total time (keeps going across rounds, never resets until restart)
    @Published private(set) var totalElapsed: TimeInterval = 0
    @Published private(set) var timeProgress: CGFloat = 0.0

    // ✅ Game over popup
    @Published var isStatsPopupPresented: Bool = false

    // ✅ Stats
    @Published private(set) var correctCount: Int = 0
    @Published private(set) var wrongCount: Int = 0

    // MARK: - Config
    private let minLength = 3
    private let maxLength = 10

    private let wordDisplaySeconds: TimeInterval = 1.8
    private let speedThreshold: TimeInterval = 15.0

    // ✅ Avoid repeating words too often
    private let recentMemoryPerLength = 6
    private var recentWordsByLength: [Int: [String]] = [:]

    // MARK: - Internal
    private var showTimer: Timer?
    private var totalTimer: Timer?
    private var typingStartDate: Date?

    // difficulty streaks
    private var correctStreak: Int = 0
    private var wrongStreak: Int = 0

    // stats timing
    private var totalAnswerSeconds: TimeInterval = 0
    private var answeredCount: Int = 0

    // total-time timer internals
    private var runningStartDate: Date?

    // MARK: - Computed for UI
    var totalTimeText: String {
        String(format: "%.2f", totalElapsed)
    }

    var averageAnswerSeconds: Double {
        guard answeredCount > 0 else { return 0.0 }
        return totalAnswerSeconds / Double(answeredCount)
    }

    var accuracyPercent: Double {
        let total = correctCount + wrongCount
        guard total > 0 else { return 0.0 }
        return (Double(correctCount) / Double(total)) * 100.0
    }

    // MARK: - Public API

    func startRound() {
        guard phase != .gameOver else { return }

        resetRoundUI()

        currentWord = pickNonRepeatingWord(length: levelLength)
        isWordHidden = false
        phase = .showingWord

        showTimer?.invalidate()
        showTimer = Timer.scheduledTimer(withTimeInterval: wordDisplaySeconds, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.isWordHidden = true
            self.phase = .typing
            self.typingStartDate = Date()
            self.startTotalTimer() // ✅ start counting total time here
        }
    }

    func submit() {
        guard phase == .typing else { return }

        stopTotalTimer() // ✅ stop counting total time here

        let trimmed = userInput
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        let correctAnswer = ReverseWordModel.reversed(currentWord).lowercased()
        let isCorrect = (trimmed == correctAnswer)

        let elapsedThisAnswer = Date().timeIntervalSince(typingStartDate ?? Date())
        totalAnswerSeconds += elapsedThisAnswer
        answeredCount += 1

        let gained = computePoints(isCorrect: isCorrect, wordLength: levelLength, elapsed: elapsedThisAnswer)
        lastRoundPoints = gained

        if isCorrect {
            correctCount += 1
            score += gained
            feedbackText = "Correct!"
            feedbackColor = Color(red: 0.10, green: 0.60, blue: 0.25)
            correctStreak += 1
            wrongStreak = 0
        } else {
            wrongCount += 1
            feedbackText = "Incorrect"
            feedbackColor = Color(red: 0.78, green: 0.18, blue: 0.18)
            wrongStreak += 1
            correctStreak = 0
        }

        // ✅ 2 wrong in a row => GAME OVER
        if wrongStreak >= 2 {
            phase = .gameOver
            isStatsPopupPresented = true
            return
        }

        updateDifficulty()
        phase = .feedback
    }

    func nextRound() {
        resetRoundUI()
        phase = .ready
    }

    // ✅ Popup buttons
    func restartGame() {
        // full reset including time + stats
        hardResetAll()
        isStatsPopupPresented = false
        phase = .ready
    }

    func goToMain() {
        // app has one screen: behave like "back to main"
        hardResetAll()
        isStatsPopupPresented = false
        phase = .ready
    }

    // MARK: - Helpers

    private func resetRoundUI() {
        showTimer?.invalidate()
        showTimer = nil

        userInput = ""
        feedbackText = ""
        isWordHidden = false
        typingStartDate = nil
        lastRoundPoints = nil
    }

    private func hardResetAll() {
        resetRoundUI()
        stopTotalTimer()
        totalElapsed = 0
        timeProgress = 0

        score = 0
        levelLength = minLength

        correctStreak = 0
        wrongStreak = 0

        correctCount = 0
        wrongCount = 0
        totalAnswerSeconds = 0
        answeredCount = 0

        recentWordsByLength = [:]
        currentWord = ""
    }

    private func updateDifficulty() {
        // senin mevcut mantığın: 2 doğru => level +1, 2 yanlış => level -1
        // ama artık 2 yanlış zaten game over, bu yüzden sadece 2 doğru yükseltecek.
        if correctStreak >= 2 {
            levelLength = min(levelLength + 1, maxLength)
            correctStreak = 0
        }
    }

    // ✅ Total time timer (forward counting across rounds)
    private func startTotalTimer() {
        guard totalTimer == nil else { return }
        runningStartDate = Date()

        totalTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] _ in
            guard let self else { return }
            guard let start = self.runningStartDate else { return }

            let delta = Date().timeIntervalSince(start)
            self.runningStartDate = Date()
            self.totalElapsed += delta

            // Visual mapping: 0..60 seconds fills the bar, then stays full.
            let maxVisual: TimeInterval = 60.0
            self.timeProgress = CGFloat(min(self.totalElapsed / maxVisual, 1.0))
        }
    }

    private func stopTotalTimer() {
        totalTimer?.invalidate()
        totalTimer = nil
        runningStartDate = nil
    }

    // ✅ Avoid recent repeats
    private func pickNonRepeatingWord(length: Int) -> String {
        let list = ReverseWordModel.wordBankByLength[length] ?? (ReverseWordModel.wordBankByLength[minLength] ?? ["cat"])
        let recent = Set(recentWordsByLength[length] ?? [])

        let candidates = list.filter { !recent.contains($0) }
        let chosen = (candidates.randomElement() ?? list.randomElement() ?? "cat")

        var arr = recentWordsByLength[length] ?? []
        arr.append(chosen)
        if arr.count > recentMemoryPerLength {
            arr.removeFirst(arr.count - recentMemoryPerLength)
        }
        recentWordsByLength[length] = arr

        return chosen
    }

    private func computePoints(isCorrect: Bool, wordLength: Int, elapsed: TimeInterval) -> Int {
        guard isCorrect else { return 0 }

        let base = wordLength * 10

        if elapsed > speedThreshold { return base }

        let remaining = max(0.0, speedThreshold - elapsed)
        let speedBonus = Int(remaining * 2.0) // max ~30 bonus
        return base + speedBonus
    }

    deinit {
        showTimer?.invalidate()
        totalTimer?.invalidate()
    }
}
