//
//  FeedConstants.swift
//  Tendria
//
//  Created by Yakup Kavak on 1.08.2025.
//

import SwiftUI


let loveModels: [LocalQuestion] = [
    
]

let gamesTitles: [QuestionLocalModel] = [
    QuestionLocalModel(
        questionType: .firefly_title,
        title: QuestionStringKeys.firefly_title,
        foregroundColor: Color(hex: "#F2AEAE"),
        backgroundColor: Color(hex: "#D95FA2")
    ),
    QuestionLocalModel(
        questionType: .catch_pair,
        title: QuestionStringKeys.catch_pair,
        foregroundColor: Color(hex: "#607EA6"),
        backgroundColor: Color(hex: "#253759")
    ),
    QuestionLocalModel(
        questionType: .wordCube,
        title: QuestionStringKeys.word_cube_title,
        foregroundColor: Color(hex: "#D95FA2"),
        backgroundColor: Color(hex: "#F2AEAE")
    ),
    QuestionLocalModel(
        questionType: .reflexGame,
        title: QuestionStringKeys.reflex_title,
        foregroundColor: Color(hex: "#252617"),
        backgroundColor: Color(hex: "#BF8A49")
    ),
    QuestionLocalModel(
        questionType: .timing,
        title: QuestionStringKeys.timing_title,
        foregroundColor: Color(hex: "#2B4C7E"),
        backgroundColor: Color(hex: "#BFD7ED")
    ),
    QuestionLocalModel(
        questionType: .reverse_word,
        title: QuestionStringKeys.reverse_word_title,
        foregroundColor: Color(hex: "#FFA44D"),
        backgroundColor: Color(hex: "#F6C28B")
    )
]

let questionTitles: [QuestionLocalModel] = [
    QuestionLocalModel(
        questionType: .colorful_words,
        title: QuestionStringKeys.colorful_words,
        foregroundColor: Color(hex: "#BF8A49"),
        backgroundColor: Color(hex: "#252617")
    ),
    QuestionLocalModel(
        questionType: .was_it_there,
        title: QuestionStringKeys.was_it_there,
        foregroundColor: Color(hex: "#607EA6"),
        backgroundColor: Color(hex: "#253759")
    ),
    QuestionLocalModel(
        questionType: .which_different,
        title: QuestionStringKeys.which_different,
        foregroundColor: Color(hex: "#A8BF56"),
        backgroundColor: Color(hex: "#658C6F")
    ),
]
