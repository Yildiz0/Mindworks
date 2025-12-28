//
//  TimingGameViewModel.swift
//  Mindwork
//
//  Created by Cemre Bayer on 28.12.2025.
//
import SwiftUI
import Combine
import QuartzCore

final class TimingGameViewModel: BaseViewModel {
    @Published var barPosition: CGFloat = 0.0
    @Published var isMovingForward = true
    @Published var gameResult: TimingResult? = nil
    @Published var score = 0
    @Published var level = 1
    @Published var gameOver = false
    
    // İstatistikler (FindColor ile uyumlu)
    @Published var correctCount: Int = 0
    @Published var wrongCount: Int = 0
    @Published var percentageTruth: Double = 0.0
    
    private var speed: CGFloat = 0.015
    private let targetPosition: CGFloat = 0.5
    private var displayLink: CADisplayLink?

    override init() {
        super.init()
        startMoving()
    }

    func startMoving() {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(updatePosition))
        displayLink?.add(to: .main, forMode: .common)
    }

    @objc private func updatePosition() {
        let currentSpeed = speed + (CGFloat(level) * 0.003)
        if isMovingForward {
            barPosition += currentSpeed
            if barPosition >= 1.0 { isMovingForward = false }
        } else {
            barPosition -= currentSpeed
            if barPosition <= 0.0 { isMovingForward = true }
        }
    }

    func stopAndCheck() {
        displayLink?.invalidate()
        let distance = abs(barPosition - targetPosition)
        
        if distance <= 0.06 {
            gameResult = .perfect
            score += 100
            correctCount += 1
            level += 1
        } else if distance <= 0.15 {
            gameResult = .good
            score += 50
            correctCount += 1
            level += 1
        } else {
            gameResult = .miss
            wrongCount += 1
            endGame()
            return
        }
        
        // Başarılıysa bir saniye sonra devam et
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.gameResult = nil
            self.startMoving()
        }
    }

    func resetGame() {
        score = 0
        level = 1
        correctCount = 0
        wrongCount = 0
        gameOver = false
        gameResult = nil
        barPosition = 0.0
        startMoving()
    }

    private func endGame() {
        displayLink?.invalidate()
        let total = correctCount + wrongCount
        percentageTruth = total > 0 ? (Double(correctCount) / Double(total)) * 100 : 0
        gameOver = true
        
        // Veri kaydetme (FirestorageManager varsa açabilirsin)
        /*
        getDataCall {
            try await FirestorageManager.shared.saveGame(...)
        } onSuccess: { _ in } onLoading: { } onError: { _ in }
        */
    }
}
