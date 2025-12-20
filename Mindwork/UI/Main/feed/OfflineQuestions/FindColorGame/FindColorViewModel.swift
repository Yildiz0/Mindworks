//
//  QuestionViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 30.07.2025.
//

import Foundation
import Combine
import SwiftUI
import FirebaseCore

final class FindColorViewModel: BaseViewModel {
    // Oyun süresi (cevap verince duracak)
    @Published var timeCounter: Double = 0.0  // saniye.cümle

    // UI hareket tetiği (hep çalışır)
    @Published var uiTick: Int = 0

    let lastQuestionNumber = 10

    @Published var questionNumber = 1 { didSet { updateProgress() } }
    @Published var questionProgress = 0.1
    @Published var questionTitle: LocalizedStringKey = StringKey.empty
    @Published var questionList: [FindColorModel] = []
    @Published var optionOne: FindColorAnswerModel?
    @Published var optionTwo: FindColorAnswerModel?
    @Published var optionThree: FindColorAnswerModel?
    @Published var optionFour: FindColorAnswerModel?
    @Published var answeredQuestion = false
    @Published var isAnswerTrue = false
    @Published var gameOver = false
    // İKİ AYRI TIMER
    private var gameTimer = Timer()
    private var uiTimer = Timer()
    // MARK: - Oyuncu istatistikleri
    @Published var correctCount: Int = 0
    @Published var wrongCount: Int = 0
    @Published var averageResponseTime: Double = 0.0  // saniye
    @Published var percentageTruth: Double = 0.0
    private var totalResponseTime: Double = 0.0
    private var totalAnswered: Int = 0
    
    override init() {
        super.init()
        initalizeList()
        startGameTimer()
        startUiTimer()         // <- sürekli çalışsın
    }

    deinit {
        stopGameTimer()
        stopUiTimer()
    }
    func startAgain() {
        stopGameTimer()

        // State reset
        timeCounter = 0.0
        questionNumber = 1
        answeredQuestion = false
        isAnswerTrue = false
        gameOver = false

        // İstatistikleri sıfırla
        correctCount = 0
        wrongCount = 0
        averageResponseTime = 0.0
        totalResponseTime = 0.0
        totalAnswered = 0

        updateProgress()

        // Soru setini baştan kur (liste uzunluğunu güvenli al)
        let pool = findColorQuestionList
        questionList = Array(pool.shuffled().prefix(lastQuestionNumber))

        applyQuestion(at: 0)
        startGameTimer()
    }

    // MARK: - Timers
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

    // MARK: - Questions
    private func initalizeList() {
        // 10 soru al (prefix(10)); through 10 = 11 olurdu
        let randomIdList = Array(0...99).shuffled().prefix(10)
        for i in randomIdList { questionList.append(findColorQuestionList[i]) }
        applyQuestion(at: 0)
    }

    private func applyQuestion(at index: Int) {
        guard questionList.indices.contains(index) else { return }
        let q = questionList[index]
        questionTitle = q.questionTitle
        optionOne   = q.options[safe: 0]
        optionTwo   = q.options[safe: 1]
        optionThree = q.options[safe: 2]
        optionFour  = q.options[safe: 3]
    }

    func checkQuestion(selectedAnswer: Int) {
        // Aynı soruya ikinci kez basılırsa sayma
        guard !answeredQuestion else { return }

        stopGameTimer() // sadece oyun süresi durur

        let answer = questionList[questionNumber - 1].options[selectedAnswer]
        answeredQuestion = true
        isAnswerTrue = answer.isTrue

        // İstatistikler
        let currentTime = timeCounter
        totalResponseTime += currentTime
        totalAnswered += 1
        averageResponseTime = totalResponseTime / Double(totalAnswered)

        if answer.isTrue {
            correctCount += 1
        } else {
            wrongCount += 1
        }
    }

    func nextQuestion() {
        if questionNumber == lastQuestionNumber { endGame(); return }
        questionNumber += 1
        prepareNewQuestion()
    }

    private func prepareNewQuestion() {
        timeCounter = 0
        answeredQuestion = false
        applyQuestion(at: questionNumber - 1)
        startGameTimer() // yeni soruda sadece oyun timer'ını tekrar başlat
    }

    func endGame() {
        stopGameTimer()
        let total = correctCount + wrongCount
        if total > 0 {
            percentageTruth = (100 * Double(correctCount) / Double(total))
        } else {
            percentageTruth = 0
        }
        gameOver = true

        getDataCall {
            try await FirestorageManager.shared.saveGame(gameData: GameStoreModel(successRate: (Double(self.correctCount) / Double((self.correctCount + self.wrongCount))), gameType: .colorful_words, date: Timestamp(date: Date()), averageTime: self.averageResponseTime))
        } onSuccess: { success in
            print("game saved")
        } onLoading: {
            print("game saving")

        } onError: { error in
            print("game couldn't saved \(error?.localizedDescription ?? "")")

        }

    }

    private func updateProgress() {
        questionProgress = Double(questionNumber) / Double(lastQuestionNumber)
    }
}

// Safe index
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
