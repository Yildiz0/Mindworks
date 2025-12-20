//
//  WhichDifferentViewModel.swift
//  Tendria
//

import Foundation
import Combine
import SwiftUI
import FirebaseCore
import FirebaseFirestore

// Tek sorunun opsiyonu
struct WhichDifferentOption {
    let imageName: String
    let isDifferent: Bool
}

// Havuz çifti
struct WDImagePair: Equatable {
    let mainImage: String
    let differentImage: String
}

// ViewModel
final class WhichDifferentViewModel: BaseViewModel {
    // MARK: - Oyun sabitleri
    let lastQuestionNumber = 10
    
    // MARK: - Yayınlanan durumlar
    @Published var timeCounter: Double = 0.0      // saniye; cevap verince durdurulur
    @Published var uiTick: Int = 0                // 1 sn’de bir artar (UI anim/etki için)
    
    @Published var questionNumber = 1 { didSet { updateProgress() } }
    @Published var questionProgress = 0.1
    @Published var questionTitle: LocalizedStringKey = StringKey.empty
    
    @Published var answeredQuestion = false
    @Published var isAnswerTrue = false
    @Published var gameOver = false
    
    // Görsel opsiyonlar (2x2)
    @Published var currentOptions: [WhichDifferentOption] = []
    
    // MARK: - İstatistikler
    @Published var correctCount: Int = 0
    @Published var wrongCount: Int = 0
    @Published var averageResponseTime: Double = 0.0   // saniye
    @Published var percentageTruth: Double = 0.0
    private var totalResponseTime: Double = 0.0
    private var totalAnswered: Int = 0
    
    // MARK: - Timer’lar
    private var gameTimer = Timer()
    private var uiTimer = Timer()
    
    // MARK: - Havuz / Soru listesi
    private var pairsPool: [WDImagePair] = [
        .init(mainImage: "bike",   differentImage: "bike1"),
        .init(mainImage: "family", differentImage: "family2"),
        .init(mainImage: "mickey1", differentImage: "mickey2"),
        .init(mainImage: "yemek",  differentImage: "yemek2"),
        // tersleri
        .init(mainImage: "bike1",   differentImage: "bike"),
        .init(mainImage: "family2", differentImage: "family"),
        .init(mainImage: "mickey2", differentImage: "mickey1"),
        .init(mainImage: "yemek2",  differentImage: "yemek")
    ]
    private var lastUsedPair: WDImagePair?
    private var usedPairs: [WDImagePair] = []
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        initializeGame()
    }
    
    deinit {
        stopGameTimer()
        stopUiTimer()
    }
    
    // MARK: - Game flow
    func startAgain() {
        stopGameTimer()
        // State reset
        timeCounter = 0.0
        questionNumber = 1
        answeredQuestion = false
        isAnswerTrue = false
        gameOver = false
        
        // İstatistikler sıfırla
        correctCount = 0
        wrongCount = 0
        averageResponseTime = 0.0
        totalResponseTime = 0.0
        totalAnswered = 0
        
        updateProgress()
        
        // Havuzu tazele
        usedPairs.removeAll()
        lastUsedPair = nil
        pairsPool.shuffle()
        
        applyQuestion()
        startGameTimer()
    }
    
    private func initializeGame() {
        updateProgress()
        pairsPool.shuffle()
        applyQuestion()
        startGameTimer()
        startUiTimer()   // UI için saniyelik tetik
    }
    
    private func applyQuestion() {
        // Başlık
        questionTitle = LocalizedStringKey("Which one is different?")
        
        // Tekrarsız bir çift seç
        var candidate: WDImagePair?
        var guardCounter = 0
        repeat {
            candidate = pairsPool.randomElement()
            guardCounter += 1
        } while (candidate == lastUsedPair || (candidate != nil && usedPairs.contains(candidate!))) && guardCounter < 50
        
        // Havuz biterse sıfırla
        if candidate == nil || guardCounter >= 50 {
            usedPairs.removeAll()
            candidate = pairsPool.randomElement()
        }
        guard let pair = candidate else { return }
        lastUsedPair = pair
        usedPairs.append(pair)
        
        // 4 opsiyonu kur (3 ana + 1 farklı), konumları karıştır
        let differentIndex = Int.random(in: 0..<4)
        var opts: [WhichDifferentOption] = []
        for i in 0..<4 {
            if i == differentIndex {
                opts.append(.init(imageName: pair.differentImage, isDifferent: true))
            } else {
                opts.append(.init(imageName: pair.mainImage, isDifferent: false))
            }
        }
        currentOptions = opts.shuffled()
    }
    
    func checkQuestion(selectedIndex: Int) {
        guard !answeredQuestion else { return }
        guard currentOptions.indices.contains(selectedIndex) else { return }
        
        stopGameTimer() // süreyi dondur
        
        let selected = currentOptions[selectedIndex]
        answeredQuestion = true
        isAnswerTrue = selected.isDifferent
        
        // İstatistikler
        let t = timeCounter
        totalResponseTime += t
        totalAnswered += 1
        averageResponseTime = totalResponseTime / Double(totalAnswered)
        
        if isAnswerTrue { correctCount += 1 } else { wrongCount += 1 }
    }
    
    func nextQuestion() {
        if questionNumber == lastQuestionNumber { endGame(); return }
        questionNumber += 1
        prepareNewQuestion()
    }
    
    private func prepareNewQuestion() {
        timeCounter = 0
        answeredQuestion = false
        applyQuestion()
        startGameTimer() // her yeni soruda süreyi yeniden başlat
    }
    
    func endGame() {
        stopGameTimer()
        let total = correctCount + wrongCount
        percentageTruth = total > 0 ? (100.0 * Double(correctCount) / Double(total)) : 0.0
        gameOver = true
        
        // Firestore’a kaydet
        getDataCall {
            try await FirestorageManager.shared.saveGame(
                gameData: GameStoreModel(
                    successRate: (Double(self.correctCount) / Double(max(1, self.correctCount + self.wrongCount))),
                    gameType: .which_different,
                    date: Timestamp(date: Date()),
                    averageTime: self.averageResponseTime // saniye/soru ortalaması
                )
            )
        } onSuccess: { _ in
            print("which_different saved")
        } onLoading: {
            print("which_different saving...")
        } onError: { error in
            print("save error \(error?.localizedDescription ?? "")")
        }
    }
    
    // MARK: - Timerlar
    private func startGameTimer() {
        stopGameTimer()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            self?.timeCounter += 0.01
        }
        RunLoop.main.add(gameTimer, forMode: .common)
    }
    private func stopGameTimer() {
        gameTimer.invalidate()
    }
    private func startUiTimer() {
        stopUiTimer()
        uiTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.uiTick += 1
        }
        RunLoop.main.add(uiTimer, forMode: .common)
    }
    private func stopUiTimer() {
        uiTimer.invalidate()
    }
    
    // MARK: - Yardımcı
    private func updateProgress() {
        questionProgress = Double(questionNumber) / Double(lastQuestionNumber)
    }
}
