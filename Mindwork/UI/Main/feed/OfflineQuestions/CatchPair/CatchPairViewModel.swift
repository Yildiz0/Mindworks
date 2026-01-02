//
//  CatchPairViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 30.07.2025.
//

import Foundation
import Combine
import SwiftUI
import FirebaseCore
import FirebaseFirestore

final class CatchPairViewModel: BaseViewModel {
    // MARK: - Faz
    private enum Phase { case waiting, showing, quiz, finished }
    private var phase: Phase = .waiting

    // Gösterim parametreleri
    private let showDurationSeconds = 8
    private let showStepSeconds = 2
    private let startDelaySeconds = 3
    private var shownCount = 0

    // MARK: - Timers
    private var gameTimer = Timer()  // sadece quiz süresi
    private var uiTimer = Timer()    // gösterim akışı + faz geçişi

    // MARK: - Oyun Durumu
    let lastQuestionNumber = 10

    @Published var timeCounter: Double = 0.0      // soru süresi (quiz fazında artar)
    @Published var uiTick: Int = 0                // her saniye artar (gösterim fazında kullan)
    @Published var questionNumber = 1 { didSet { updateProgress() } }
    @Published var questionProgress = 0.1
    @Published var currentNumber: LocalizedStringKey = StringKey.loading
    @Published var questionList: [CatchNumberQuestion] = []
    @Published var questionTitle: LocalizedStringKey = StringKey.loading
    @Published var answeredQuestion = true
    @Published var isAnswerTrue = false
    @Published var gameOver = false

    // MARK: - İstatistikler
    @Published var correctCount: Int = 0
    @Published var wrongCount: Int = 0
    @Published var averageResponseTime: Double = 0.0
    @Published var percentageTruth: Double = 0.0
    @Published var preparingGame = true
    @Published var waitingToStart = true
    @Published var isTrue: Bool? = nil
    private var totalResponseTime: Double = 0.0
    private var totalAnswered: Int = 0

    // MARK: - Veri
    private var numberList = [0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,9,9,9].shuffled()
    private var colorList: [Color] = [.blue,.green,.orange,.pink,.brown,.purple,.indigo,.yellow,.green,.teal,.brown,.purple,.indigo,.yellow,.green,.teal,.blue,.green,.orange,.pink,.brown,.purple,.indigo,.yellow,.green,.teal,.brown,.purple,.indigo,.yellow,.green,.teal]
    @Published var randomColor: Color = .blue
    private var currentNumberIndex = 0
    private var askedIndex: Int = 0

    // MARK: - Lifecycle
    override init() {
        super.init()
        initializeQuestions()
        startUiTimer()
        startWaitingPhase()
    }

    deinit {
        stopGameTimer()
        stopUiTimer()
    }

    // MARK: - Public API
    func startAgain() {
        answeredQuestion = true
        stopGameTimer()
        print("Your current index -> \(currentNumberIndex)")
        print("Numbers -> \(numberList)")
        // skor/süre reset
        timeCounter = 0.0
        questionNumber = 1
        questionProgress = Double(questionNumber) / Double(lastQuestionNumber)
        isAnswerTrue = false
        gameOver = false
        isTrue = nil
        correctCount = 0
        wrongCount = 0
        averageResponseTime = 0.0
        totalResponseTime = 0.0
        totalAnswered = 0
        percentageTruth = 0

        // verileri reset
        numberList = [0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,9,9,9].shuffled()
        initializeQuestions()

        // faz
        startWaitingPhase()
    }

    func checkQuestion(selectedNumber: Int) {
        guard phase == .quiz, !answeredQuestion else { return }

        // En son gösterilen index = currentNumberIndex - 1
        let lastShown = currentNumberIndex - 1
        let targetIndex = lastShown - askedIndex

        // ÖNCE guard, sonra erişim!
        guard targetIndex >= 0, targetIndex < numberList.count else {
            answeredQuestion = true
            isAnswerTrue = false
            wrongAnswer()
            accumulateTime()
            nextQuestion()
            return
        }

        let trueAnswer = numberList[targetIndex]
        answeredQuestion = true
        isAnswerTrue = (trueAnswer == selectedNumber)

        if isAnswerTrue { correctAnswer() } else { wrongAnswer() }
        accumulateTime()
        nextQuestion()
    }

    func nextQuestion() {
        guard phase == .quiz else { return }
        if questionNumber == lastQuestionNumber {
            endGame()
            return
        }
        questionNumber += 1
        randomColor = colorList[questionNumber]
        showNextNumber()
        prepareNewQuestion()
    }
    
    private func correctAnswer(){
        correctCount += 1
        isTrue = true
    }
    private func wrongAnswer(){
        wrongCount += 1
        isTrue = false
    }

    func startGame() {
        guard phase == .waiting else { return }
        startShowPhase()
    }

    // MARK: - Faz Yönetimi
    private func startWaitingPhase() {
           phase = .waiting
           timeCounter = 0
           uiTick = 0
           shownCount = 0
           currentNumberIndex = 0
           currentNumber = StringKey.start
           questionTitle = StringKey.catchpair_intro
           preparingGame = true
           waitingToStart = true
           randomColor = .blue
       }

    private func startShowPhase() {
        phase = .showing
        timeCounter = 0
        uiTick = 0
        shownCount = 0
        currentNumberIndex = 0
        currentNumber = StringKey.empty
        questionTitle = StringKey.start_remember
        preparingGame = true
        waitingToStart = false
    }

    private func startQuizPhase() {
        phase = .quiz
        timeCounter = 0
        questionNumber = 1
        answeredQuestion = false
        isAnswerTrue = false
        preparingGame = false
        waitingToStart = false
        applyQuestion(at: 0)
        startGameTimer()
    }

    private func endGame() {
        stopGameTimer()
        phase = .finished
        isTrue = nil
        let total = correctCount + wrongCount
        percentageTruth = total > 0 ? (100.0 * Double(correctCount) / Double(total)) : 0.0
        averageResponseTime = timeCounter / 10.0
        gameOver = true

        getDataCall {
            try await FirestorageManager.shared.saveGame(
                gameData: GameStoreModel(
                    successRate: (Double(self.correctCount) / Double(max(1, self.correctCount + self.wrongCount))),
                    gameType: .catch_pair, // ihtiyaca göre değiştir
                    date: Timestamp(date: Date()),
                    averageTime: self.averageResponseTime
                )
            )
        } onSuccess: { _ in
            print("game saved")
        } onLoading: {
            print("game saving")
        } onError: { error in
            print("game couldn't saved \(error?.localizedDescription ?? "")")
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
            guard let self = self else { return }
            self.uiTick += 1

            switch self.phase {
            case .waiting:
                break
            case .showing:
                // kısa gecikmeden sonra sayıları aralıklarla göster
                if self.uiTick >= self.startDelaySeconds {
                    let adjustedTick = self.uiTick - self.startDelaySeconds
                    if adjustedTick % self.showStepSeconds == 0, self.uiTick <= self.showDurationSeconds {
                        self.showNextNumber()
                        self.shownCount += 1
                        self.answeredQuestion = true
                    }
                }
                // gösterim tamamlandı → quiz
                if self.uiTick >= self.showDurationSeconds {
                    self.startQuizPhase()
                }

            case .quiz, .finished:
                break
            }
        }
        RunLoop.main.add(uiTimer, forMode: .common)
    }

    private func stopUiTimer() {
        uiTimer.invalidate()
    }

    // MARK: - Sorular
    private func initializeQuestions() {
        questionList = buildQuestionList()
        applyQuestion(at: 0)
    }

    private func applyQuestion(at index: Int) {
        guard questionList.indices.contains(index) else { return }
        let q = questionList[index]
        questionTitle = q.questionTitle
        askedIndex = q.beforeNumber   // kaç adım geriye bakılacağını belirler
    }

    private func prepareNewQuestion() {
        answeredQuestion = false
        applyQuestion(at: questionNumber - 1)
        //startGameTimer()
    }

    // MARK: - Yardımcılar
    private func buildQuestionList() -> [CatchNumberQuestion] {
        let totalQuestions = lastQuestionNumber
        let baseCount = totalQuestions / 3
        let remainder = totalQuestions % 3
        var counts: [Int: Int] = [1: baseCount, 2: baseCount, 3: baseCount]

        if remainder > 0 {
            let extras = [1, 2, 3].shuffled().prefix(remainder)
            extras.forEach { counts[$0, default: 0] += 1 }
        }

        var result: [CatchNumberQuestion] = []
        var lastTwo: [Int] = []

        while result.count < totalQuestions {
            let disallowed = (lastTwo.count == 2 && lastTwo[0] == lastTwo[1]) ? lastTwo[0] : nil
            let available = counts.filter { $0.value > 0 }.map(\.key)
            let allowed = disallowed.map { disallowedValue in
                available.filter { $0 != disallowedValue }
            } ?? available
            let pickPool = allowed.isEmpty ? available : allowed
            guard let picked = weightedPick(from: pickPool, counts: counts) else { break }

            result.append(makeQuestion(beforeNumber: picked))
            counts[picked, default: 0] -= 1

            lastTwo.append(picked)
            if lastTwo.count > 2 { lastTwo.removeFirst() }
        }

        return result
    }

    private func weightedPick(from options: [Int], counts: [Int: Int]) -> Int? {
        let total = options.reduce(0) { $0 + max(0, counts[$1, default: 0]) }
        guard total > 0 else { return nil }
        var roll = Int.random(in: 1...total)
        for option in options {
            roll -= max(0, counts[option, default: 0])
            if roll <= 0 { return option }
        }
        return options.last
    }

    private func makeQuestion(beforeNumber: Int) -> CatchNumberQuestion {
        switch beforeNumber {
        case 1:
            return CatchNumberQuestion(questionTitle: StringKey.one_before, beforeNumber: 1)
        case 2:
            return CatchNumberQuestion(questionTitle: StringKey.two_before, beforeNumber: 2)
        case 3:
            return CatchNumberQuestion(questionTitle: StringKey.three_before, beforeNumber: 3)
        default:
            return CatchNumberQuestion(questionTitle: StringKey.one_before, beforeNumber: 1)
        }
    }
    private func showNextNumber() {
        guard currentNumberIndex < numberList.count else { return }
        currentNumber = getNumberString(number: numberList[currentNumberIndex])
        currentNumberIndex += 1
        print("Your current index -> \(currentNumberIndex)")
        print("Numbers -> \(numberList)")
    }

    private func accumulateTime() {
        let t = timeCounter
        totalResponseTime += t
        totalAnswered += 1
        averageResponseTime = totalResponseTime / Double(totalAnswered)
    }

    private func getNumberString(number: Int) -> LocalizedStringKey {
        switch number {
        case 0: return StringKey.number_zero
        case 1: return StringKey.number_one
        case 2: return StringKey.number_two
        case 3: return StringKey.number_three
        case 4: return StringKey.number_four
        case 5: return StringKey.number_five
        case 6: return StringKey.number_six
        case 7: return StringKey.number_seven
        case 8: return StringKey.number_eight
        case 9: return StringKey.number_nine
        default: return StringKey.empty
        }
    }

    private func updateProgress() {
        questionProgress = Double(questionNumber) / Double(lastQuestionNumber)
    }
}
