//
//  FindColorModel.swift
//  Mindwork
//
//  Created by Yakup Kavak on 11.08.2025.
//

import SwiftUI

struct FindColorModel {
    var questionTitle: LocalizedStringKey
    var options: [FindColorAnswerModel]
}

struct FindColorAnswerModel{
    var optionColor: Color
    var optionText: LocalizedStringKey
    var isTrue: Bool
}
let askCatchNumber: [CatchNumberQuestion] = [
    CatchNumberQuestion(questionTitle: StringKey.one_before, beforeNumber: 1),
    CatchNumberQuestion(questionTitle: StringKey.two_before, beforeNumber: 2),
    CatchNumberQuestion(questionTitle: StringKey.three_before, beforeNumber: 3),
    CatchNumberQuestion(questionTitle: StringKey.one_before, beforeNumber: 1),
    CatchNumberQuestion(questionTitle: StringKey.two_before, beforeNumber: 2),
    CatchNumberQuestion(questionTitle: StringKey.three_before, beforeNumber: 3),
    CatchNumberQuestion(questionTitle: StringKey.one_before, beforeNumber: 1),
    CatchNumberQuestion(questionTitle: StringKey.two_before, beforeNumber: 2),
    CatchNumberQuestion(questionTitle: StringKey.three_before, beforeNumber: 3),
    CatchNumberQuestion(questionTitle: StringKey.one_before, beforeNumber: 1),
    CatchNumberQuestion(questionTitle: StringKey.two_before, beforeNumber: 2),
    CatchNumberQuestion(questionTitle: StringKey.three_before, beforeNumber: 3),
    CatchNumberQuestion(questionTitle: StringKey.one_before, beforeNumber: 1),
    CatchNumberQuestion(questionTitle: StringKey.two_before, beforeNumber: 2),
    CatchNumberQuestion(questionTitle: StringKey.three_before, beforeNumber: 3),
    CatchNumberQuestion(questionTitle: StringKey.one_before, beforeNumber: 1),
    CatchNumberQuestion(questionTitle: StringKey.two_before, beforeNumber: 2),
    CatchNumberQuestion(questionTitle: StringKey.three_before, beforeNumber: 3),
    CatchNumberQuestion(questionTitle: StringKey.one_before, beforeNumber: 1),
    CatchNumberQuestion(questionTitle: StringKey.two_before, beforeNumber: 2),
    CatchNumberQuestion(questionTitle: StringKey.three_before, beforeNumber: 3),
    CatchNumberQuestion(questionTitle: StringKey.one_before, beforeNumber: 1),
    CatchNumberQuestion(questionTitle: StringKey.two_before, beforeNumber: 2),
    CatchNumberQuestion(questionTitle: StringKey.three_before, beforeNumber: 3)
]

struct CatchNumberQuestion{
    var questionTitle: LocalizedStringKey
    var beforeNumber: Int
}

let findColorQuestionList: [FindColorModel] = [
    
    // which_color_blue (12 adet)
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_white,
        options: [
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_red, isTrue: true),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .gray, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_gray, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_white,
        options: [
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_black, isTrue: true),
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_pink, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_yellow, isTrue: false)
        ]
    ),
    
    // 3) BLACK
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_black,
        options: [
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_white, isTrue: true),
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .gray, optionText: FindColorStringKeys.text_gray, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_brown, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_black,
        options: [
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_yellow, isTrue: true),
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_orange, isTrue: false)
        ]
    ),
    
    // 5) GRAY
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_gray,
        options: [
            FindColorAnswerModel(optionColor: .gray, optionText: FindColorStringKeys.text_black, isTrue: true),
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_gray, isTrue: false),
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_purple, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_gray,
        options: [
            FindColorAnswerModel(optionColor: .gray, optionText: FindColorStringKeys.text_yellow, isTrue: true),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_gray, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_white, isTrue: false)
        ]
    ),
    
    // 7) DARK GRAY
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_darkgray,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.2, green: 0.2, blue: 0.2), optionText: FindColorStringKeys.text_white, isTrue: true),
            FindColorAnswerModel(optionColor: Color(red: 0.85, green: 0.85, blue: 0.85), optionText: FindColorStringKeys.text_darkgray, isTrue: false),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_gray, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_darkgray,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.2, green: 0.2, blue: 0.2), optionText: FindColorStringKeys.text_pink, isTrue: true),
            FindColorAnswerModel(optionColor: .gray, optionText: FindColorStringKeys.text_darkgray, isTrue: false),
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_lightgray, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_white, isTrue: false)
        ]
    ),
    
    // 9) LIGHT GRAY
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_lightgray,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.85, green: 0.85, blue: 0.85), optionText: FindColorStringKeys.text_black, isTrue: true),
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_lightgray, isTrue: false),
            FindColorAnswerModel(optionColor: .gray, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_gray, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_lightgray,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.85, green: 0.85, blue: 0.85), optionText: FindColorStringKeys.text_purple, isTrue: true),
            FindColorAnswerModel(optionColor: Color(red: 0.2, green: 0.2, blue: 0.2), optionText: FindColorStringKeys.text_lightgray, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_brown, isTrue: false)
        ]
    ),
    
    // 11) RED
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_red,
        options: [
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_white, isTrue: true),
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_red, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_purple, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_red,
        options: [
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_gray, isTrue: true),
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_red, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_orange, isTrue: false)
        ]
    ),
    
    // 13) DARK GREEN
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_darkgreen,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.0, green: 0.5, blue: 0.0), optionText: FindColorStringKeys.text_black, isTrue: true),
            FindColorAnswerModel(optionColor: Color(red: 0.6, green: 0.9, blue: 0.6), optionText: FindColorStringKeys.text_darkgreen, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_brown, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_darkgreen,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.0, green: 0.5, blue: 0.0), optionText: FindColorStringKeys.text_white, isTrue: true),
            FindColorAnswerModel(optionColor: .green, optionText: FindColorStringKeys.text_darkgreen, isTrue: false),
            FindColorAnswerModel(optionColor: Color(red: 0.6, green: 0.9, blue: 0.6), optionText: FindColorStringKeys.text_lightgreen, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_orange, isTrue: false)
        ]
    ),
    
    // 15) LIGHT GREEN
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_lightgreen,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.6, green: 0.9, blue: 0.6), optionText: FindColorStringKeys.text_black, isTrue: true),
            FindColorAnswerModel(optionColor: Color(red: 0.0, green: 0.5, blue: 0.0), optionText: FindColorStringKeys.text_lightgreen, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_white, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_lightgreen,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.6, green: 0.9, blue: 0.6), optionText: FindColorStringKeys.text_gray, isTrue: true),
            FindColorAnswerModel(optionColor: .green, optionText: FindColorStringKeys.text_lightgreen, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_yellow, isTrue: false)
        ]
    ),
    
    // 17) DARK BLUE
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_darkblue,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.0, green: 0.0, blue: 0.5), optionText: FindColorStringKeys.text_white, isTrue: true),
            FindColorAnswerModel(optionColor: Color(red: 0.6, green: 0.8, blue: 1.0), optionText: FindColorStringKeys.text_darkblue, isTrue: false),
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_blue, isTrue: false),
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_black, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_darkblue,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.0, green: 0.0, blue: 0.5), optionText: FindColorStringKeys.text_pink, isTrue: true),
            FindColorAnswerModel(optionColor: .blue, optionText: FindColorStringKeys.text_darkblue, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_gray, isTrue: false)
        ]
    ),
    
    // 19) LIGHT BLUE
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_lightblue,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.6, green: 0.8, blue: 1.0), optionText: FindColorStringKeys.text_black, isTrue: true),
            FindColorAnswerModel(optionColor: Color(red: 0.0, green: 0.0, blue: 0.5), optionText: FindColorStringKeys.text_lightblue, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_blue, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_white, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_lightblue,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.6, green: 0.8, blue: 1.0), optionText: FindColorStringKeys.text_gray, isTrue: true),
            FindColorAnswerModel(optionColor: .blue, optionText: FindColorStringKeys.text_lightblue, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_orange, isTrue: false)
        ]
    ),
    
    // 21) YELLOW
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_yellow,
        options: [
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black, isTrue: true),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_purple, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_yellow,
        options: [
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_gray, isTrue: true),
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_orange, isTrue: false)
        ]
    ),
    
    // 23) ORANGE
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_orange,
        options: [
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_white, isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_orange, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_gray, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_orange,
        options: [
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_gray, isTrue: true),
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_orange, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_brown, isTrue: false)
        ]
    ),
    
    // 25) PURPLE
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_purple,
        options: [
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_white, isTrue: true),
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_purple, isTrue: false),
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_gray, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_purple,
        options: [
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_yellow, isTrue: true),
            FindColorAnswerModel(optionColor: .blue, optionText: FindColorStringKeys.text_purple, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_orange, isTrue: false)
        ]
    ),
    
    // 27) PINK
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_pink,
        options: [
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_black, isTrue: true),
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_pink, isTrue: false),
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_gray, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_white, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_pink,
        options: [
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_gray, isTrue: true),
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_pink, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_orange, isTrue: false)
        ]
    ),
    
    // 29) BROWN
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_brown,
        options: [
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_white, isTrue: true),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_brown, isTrue: false),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_gray, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_pink, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_brown,
        options: [
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_yellow, isTrue: true),
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_brown, isTrue: false),
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_orange, isTrue: false)
        ]
    ),
    
    // 31) TURQUOISE (use teal-ish)
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_turquoise,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.25, green: 0.8, blue: 0.75), optionText: FindColorStringKeys.text_black, isTrue: true),
            FindColorAnswerModel(optionColor: .blue, optionText: FindColorStringKeys.text_turquoise, isTrue: false),
            FindColorAnswerModel(optionColor: .green, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_gray, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_turquoise,
        options: [
            FindColorAnswerModel(optionColor: Color(red: 0.25, green: 0.8, blue: 0.75), optionText: FindColorStringKeys.text_white, isTrue: true),
            FindColorAnswerModel(optionColor: .cyan, optionText: FindColorStringKeys.text_turquoise, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_blue, isTrue: false)
        ]
    ),
    
    // --- WHICH TEXT (no green/blue text questions to avoid repeats) ---
    
    // 33) TEXT WHITE
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_white,
        options: [
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_white, isTrue: true),
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .gray, optionText: FindColorStringKeys.text_gray, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_purple, isTrue: false)
        ]
    ),
    // 34) TEXT BLACK
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_black,
        options: [
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black, isTrue: true),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .gray, optionText: FindColorStringKeys.text_brown, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_gray, isTrue: false)
        ]
    ),
    // 35) TEXT GRAY
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_gray,
        options: [
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_gray, isTrue: true),
            FindColorAnswerModel(optionColor: .gray, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_orange, isTrue: false)
        ]
    ),
    // 36) TEXT DARK GRAY
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_darkgray,
        options: [
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_darkgray, isTrue: true),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_gray, isTrue: false),
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_lightgray, isTrue: false),
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_black, isTrue: false)
        ]
    ),
    // 37) TEXT LIGHT GRAY
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_lightgray,
        options: [
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_lightgray, isTrue: true),
            FindColorAnswerModel(optionColor: .gray, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_darkgray, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_gray, isTrue: false)
        ]
    ),
    // 38) TEXT RED
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_red,
        options: [
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_red, isTrue: true),
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_pink, isTrue: false),
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_brown, isTrue: false)
        ]
    ),
    // 39) TEXT DARK GREEN
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_darkgreen,
        options: [
            FindColorAnswerModel(optionColor: .blue, optionText: FindColorStringKeys.text_darkgreen, isTrue: true),
            FindColorAnswerModel(optionColor: .green, optionText: FindColorStringKeys.text_lightgreen, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_orange, isTrue: false)
        ]
    ),
    // 40) TEXT LIGHT GREEN
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_lightgreen,
        options: [
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_lightgreen, isTrue: true),
            FindColorAnswerModel(optionColor: .green, optionText: FindColorStringKeys.text_darkgreen, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green, isTrue: false),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_white, isTrue: false)
        ]
    ),
    // 41) TEXT DARK BLUE
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_darkblue,
        options: [
            FindColorAnswerModel(optionColor: .green, optionText: FindColorStringKeys.text_darkblue, isTrue: true),
            FindColorAnswerModel(optionColor: .blue, optionText: FindColorStringKeys.text_lightblue, isTrue: false),
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_blue, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black, isTrue: false)
        ]
    ),
    // 42) TEXT LIGHT BLUE
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_lightblue,
        options: [
            FindColorAnswerModel(optionColor: .red, optionText: FindColorStringKeys.text_lightblue, isTrue: true),
            FindColorAnswerModel(optionColor: .blue, optionText: FindColorStringKeys.text_darkblue, isTrue: false),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_gray, isTrue: false)
        ]
    ),
    // 43) TEXT YELLOW
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_yellow,
        options: [
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_yellow, isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_purple, isTrue: false)
        ]
    ),
    // 44) TEXT ORANGE
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_orange,
        options: [
            FindColorAnswerModel(optionColor: .blue, optionText: FindColorStringKeys.text_orange, isTrue: true),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_yellow, isTrue: false)
        ]
    ),
    // 45) TEXT PURPLE
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_purple,
        options: [
            FindColorAnswerModel(optionColor: .green, optionText: FindColorStringKeys.text_purple, isTrue: true),
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_gray, isTrue: false)
        ]
    ),
    // 46) TEXT PINK
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_pink,
        options: [
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_pink, isTrue: true),
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_orange, isTrue: false)
        ]
    ),
    // 47) TEXT BROWN
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_brown,
        options: [
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_brown, isTrue: true),
            FindColorAnswerModel(optionColor: .brown, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_gray, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_yellow, isTrue: false)
        ]
    ),
    // 48) TEXT TURQUOISE
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_turquoise,
        options: [
            FindColorAnswerModel(optionColor: .purple, optionText: FindColorStringKeys.text_turquoise, isTrue: true),
            FindColorAnswerModel(optionColor: Color(red: 0.25, green: 0.8, blue: 0.75), optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .blue, optionText: FindColorStringKeys.text_green, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black, isTrue: false)
        ]
    ),
    // 49) TEXT WHITE (variant)
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_white,
        options: [
            FindColorAnswerModel(optionColor: .blue, optionText: FindColorStringKeys.text_white, isTrue: true),
            FindColorAnswerModel(optionColor: .white, optionText: FindColorStringKeys.text_gray, isTrue: false),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_black, isTrue: false),
            FindColorAnswerModel(optionColor: .orange, optionText: FindColorStringKeys.text_yellow, isTrue: false)
        ]
    ),
    // 50) TEXT BLACK (variant)
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_black,
        options: [
            FindColorAnswerModel(optionColor: .green, optionText: FindColorStringKeys.text_black, isTrue: true),
            FindColorAnswerModel(optionColor: .black, optionText: FindColorStringKeys.text_white, isTrue: false),
            FindColorAnswerModel(optionColor: .gray, optionText: FindColorStringKeys.text_darkgray, isTrue: false),
            FindColorAnswerModel(optionColor: .pink, optionText: FindColorStringKeys.text_brown, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_blue,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_red,    isTrue: true),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_blue,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_black,  isTrue: true),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_blue,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_blue,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_yellow, isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_blue,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_blue,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_black,  isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_blue,   isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_blue,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_red,    isTrue: true),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_blue,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_black,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_blue,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_black,  isTrue: true),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_blue,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_yellow, isTrue: true),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_blue,   isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_blue,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_red,    isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_blue,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_red,    isTrue: true),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_black,  isTrue: false)
        ]
    ),
    
    // which_color_green (12 adet)
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_yellow, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_black,  isTrue: true),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_yellow, isTrue: true),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_red,    isTrue: true),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_blue,   isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_black,  isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_yellow, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_yellow, isTrue: true),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_blue,   isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_red,    isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_yellow, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_black,  isTrue: true),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_yellow, isTrue: true),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_color_green,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_red,    isTrue: false)
        ]
    ),
    
    // which_text_green (13 adet) — doğru: mavi renkli "Yeşil"
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_blue,   isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_blue,   isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_red,    isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_black,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_blue,   isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_blue,   isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_black,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_yellow, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_yellow, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_red,    isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_yellow, isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_green,
        options: [
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: true),
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false)
        ]
    ),
    
    // which_text_blue (13 adet) — doğru: yeşil renkli "Mavi"
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_red,    isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_black,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_black,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_yellow, isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_green,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .red,    optionText: FindColorStringKeys.text_black,  isTrue: false),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_red,    isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_blue,   isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_black,  isTrue: false)
        ]
    ),
    FindColorModel(
        questionTitle: FindColorStringKeys.which_text_blue,
        options: [
            FindColorAnswerModel(optionColor: .green,  optionText: FindColorStringKeys.text_blue,   isTrue: true),
            FindColorAnswerModel(optionColor: .blue,   optionText: FindColorStringKeys.text_green,  isTrue: false),
            FindColorAnswerModel(optionColor: .yellow, optionText: FindColorStringKeys.text_red,    isTrue: false),
            FindColorAnswerModel(optionColor: .black,  optionText: FindColorStringKeys.text_black,  isTrue: false)
        ]
    )
]
