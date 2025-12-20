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
    
    private var timer: Timer?
    private var delay: Double = 1.5
    private let minDelay: Double = 0.6
    
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
        message = "Bu tur Yeşil ve Sarı’da bekleyeceksin, Kırmızı’da dokunacaksın!"
        gameState = .running
        nextColor()
    }
    
    func stopGame() {
        gameState = .gameOver
        timer?.invalidate()
        if score > highScore {
            highScore = score
        }
        message = "Oyun bitti! Puanın: \(score)"
    }
    
    func handleTap() {
        guard gameState == .running else { return }
        
        if currentColor == .red {
            score += 1
            nextColor() // mesaj değişmeden devam etsin
        } else {
            stopGame()
        }
    }
    
    private func nextColor() {
        timer?.invalidate()
        
        let next = GameColor.allCases.randomElement()!
        currentColor = next
        
        let nextDelay = max(delay - (Double(score) * 0.05), minDelay)
        timer = Timer.scheduledTimer(withTimeInterval: nextDelay, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.nextColor()
        }
    }
}
