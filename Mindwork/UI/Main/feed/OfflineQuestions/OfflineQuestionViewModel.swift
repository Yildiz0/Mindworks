//
//  QuestionViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 30.07.2025.
//

import Foundation
import Combine
import SwiftUI

class QuestionViewModel: BaseViewModel{
    @Published var timeRemaining: Int
    @AppStorage(Constants.UserDefaultsKeys.questionTime)
    private var defaultTime: Int = 30
    let lastQuestionNumber = 10
    
    @Published var questionNumber = 1{
        didSet {
            updateProgress()
        }
    }
    
    @Published var questionProgress = 0.1
    @Published var questionTitle: LocalizedStringKey = StringKey.empty
    @Published var questionDescription: LocalizedStringKey = StringKey.empty
    @Published var isTimeOver = false
    @Published var questionList: [LocalQuestion] = [LocalQuestion]()
    @Published var error: Error?
    var questionType: QuestionType
    private var repeatTimer = true
    
    private var timer = Timer()
    
    init(questionType: QuestionType) {
        let savedTime = UserDefaults.standard.integer(forKey: Constants.UserDefaultsKeys.questionTime)
        self.timeRemaining = savedTime == 0 ? 30 : savedTime
        self.questionType = questionType
        super.init()
        enableTimer()
        getQuestions(questionType: questionType)
    }
    
    private func getQuestions(questionType: QuestionType){
        /*
        switch questionType{
           
            case .dreams:
                initalizeList(list: dreamsQuestionModels)
            case .favorites:
                initalizeList(list: favoritesQuestionModels)
            case .firsts:
                initalizeList(list: firstsQuestionModels)
            case .life:
                initalizeList(list: lifeQuestionModels)
            case .love:
                initalizeList(list: loveQuestionModels)
            case .philosophy:
                initalizeList(list: philosophyQuestionModels)
            case .trust:
                initalizeList(list: trustQuestionModels)
        }
             */
    }
    
    private func initalizeList(list: [LocalQuestion]){
        let randomIdList = getRandomNumberArray(startIndex: 0, endIndex: 9, numberCount: 10)
        guard let randomIdList else { error = RelationError.unknown ; return }
        for randomId in randomIdList{
            questionList.append(list[randomId])
        }
        questionTitle = questionList[0].questionTitle
        questionDescription = questionList[0].questionDescription
    }
    
    private func getRandomNumberArray(startIndex: Int, endIndex: Int, numberCount: Int) -> [Int]?{
        if(endIndex - startIndex < numberCount - 1) {
            return nil
        }
        var returnList = [Int]()
        var errorCheck = 0
        let errorLimit = numberCount * 30
        
        for _ in 1...numberCount{
            var newNumber = Int.random(in: startIndex...endIndex)
            while returnList.contains(newNumber){
                newNumber = Int.random(in: startIndex...endIndex)
                if(errorCheck == errorLimit){
                    return nil
                }
                errorCheck += 1
            }
            errorCheck = 0
            returnList.append(newNumber)
        }
        return returnList
    }
    
    func updateDefaultTime(to newValue: Int) {
        defaultTime   = newValue          // @AppStorage → UserDefaults’a yazar
        timeRemaining = newValue          // aktif sayacı sıfırlar
    }
    
    func enableTimer(){
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: repeatTimer, block: { _ in
            DispatchQueue.main.async { [weak self] in
                if(self?.timeRemaining != 1){
                    self?.timeRemaining -= 1
                }else {
                    self?.isTimeOver = true
                    self?.repeatTimer = false
                }
            }
        })
    }
    
    func nextQuestion() {
        if(questionNumber == lastQuestionNumber){
            endGame()
        }else {
            questionNumber += 1
            prepareNewQuestion()
        }
    }
    
    func backQuestion() {
        if(questionNumber != 1){
            questionNumber -= 1
            prepareNewQuestion()
        }
    }
    
    private func prepareNewQuestion(){
        timeRemaining = defaultTime
        repeatTimer = true
        isTimeOver = false
        questionTitle = questionList[questionNumber - 1].questionTitle
        questionDescription = questionList[questionNumber - 1].questionDescription
    }
    
    func endGame(){
        
    }
    
    private func updateProgress() {
        questionProgress = Double(questionNumber) / 10.0
    }
}
