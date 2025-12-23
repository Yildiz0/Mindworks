//
//  ReflexGameViewModel.swift
//  Reflex
//
//  Created by Sena Yıldız on 13.11.2025.
//

import SwiftUI
import Combine

final class ReflexGameViewModel: ObservableObject {
    @Published var score = 0
    @Published var highScore = 0
    @Published var currentColor: GameColor = .green
    @Published var gameState: GameState = .ready
    @Published var message = ""
    @Published var lastScoreDelta: Int?
    @Published var showScoreDelta = false
    
    private var timer: Timer?
    private var delay: Double = 1.5
    private let minDelay: Double = 0.6
    private var redShownAt: Date?
    private var hideScoreDeltaWorkItem: DispatchWorkItem?
    
    enum GameState {
        case ready, running, gameOver
    }
    
    enum GameColor: CaseIterable {
        case green, yellow, red
        
        var color: Color {
            switch self {
            case .green: return .green
            case .yellow: return .yellow
            case .red: return .red
            }
        }
    }
    
    func startGame() {
        score = 0
        redShownAt = nil
        lastScoreDelta = nil
        showScoreDelta = false
        message = "Bu tur Yeşil ve Sarı’da bekleyeceksin, Kırmızı’da dokunacaksın!"
        gameState = .running
        nextColor()
    }
    
    func stopGame() {
        gameState = .gameOver
        timer?.invalidate()
        hideScoreDeltaWorkItem?.cancel()
        showScoreDelta = false
        if score > highScore {
            highScore = score
        }
        message = "Oyun bitti! Puanın: \(score)"
    }
    
    func handleTap() {
        guard gameState == .running else { return }
        
        if currentColor == .red {
            let bonus: Int
            if let redShownAt {
                let reactionTimeMs = max(0, Date().timeIntervalSince(redShownAt) * 1000)
                let maxWindowMs = minDelay * 1000
                let remainingMs = max(0, maxWindowMs - reactionTimeMs)
                bonus = Int(remainingMs / 10)
            } else {
                bonus = 0
            }
            let delta = 1 + bonus
            score += delta
            showScoreDelta(delta)
            nextColor() // mesaj değişmeden devam etsin
        } else {
            stopGame()
        }
    }
    
    private func nextColor() {
        timer?.invalidate()
        
        let next = GameColor.allCases.randomElement()!
        currentColor = next
        redShownAt = next == .red ? Date() : nil
        
        let nextDelay = max(delay - (Double(score) * 0.05), minDelay)
        timer = Timer.scheduledTimer(withTimeInterval: nextDelay, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.nextColor()
        }
    }

    private func showScoreDelta(_ delta: Int) {
        lastScoreDelta = delta
        showScoreDelta = true
        hideScoreDeltaWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.showScoreDelta = false
        }
        hideScoreDeltaWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: workItem)
    }
}
