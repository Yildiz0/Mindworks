//
//  QuestionUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 30.07.2025.
//

import SwiftUI

struct OfflineQuestionUI: View {
    var questionType: QuestionType
    @StateObject var viewModel: QuestionViewModel
    @EnvironmentObject var router: RouterFeed
    @State private var showTimeSheet = false
    @AppStorage(Constants.UserDefaultsKeys.questionTime) private var defaultTime = 30

    init(questionType: QuestionType) {
        self.questionType = questionType
        _viewModel = StateObject(wrappedValue: QuestionViewModel(questionType: questionType))
    }
    
    var body: some View {
        VStack{
            HStack{
                btnSystemIconTransparent(iconSystemName: Icons.left_direction, color: Color.black) {
                    router.navigateBack()
                }
                Spacer()
                tvBodylineString(text: String(format: NSLocalizedString("question_number", comment: ""), viewModel.questionNumber), color: .black)
                Spacer()
                btnSystemIconTransparent(iconSystemName: "ellipsis.circle", color: .black) {
                    showTimeSheet = true
                }
            }
            ProgressView(value: viewModel.questionProgress).padding(.top).tint(.orange500).scaleEffect(x: 1,y: 2, anchor: .center)
            
            tvBodylineString(text: viewModel.isTimeOver ? "" : "\(viewModel.timeRemaining)", color: .black).padding(.top)
            tvBodyline(text: viewModel.isTimeOver ? QuestionStringKeys.answer_question : QuestionStringKeys.think_question, color: .gray)
            
            Spacer()
            
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.gray)
                    .overlay {
                        tvBodyline(text: viewModel.questionTitle, color: .black)
                    }
                    .frame(width: 200,height: 80)
                    .background(Color.clear).offset(y:-100)
                    .zIndex(2.0)
                
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.orange)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity,maxHeight: 200)
                    .background(Color.clear)
                    .zIndex(1.9)
                    .overlay {
                        tvBodyline(text: viewModel.questionDescription, color: .black)
                            .multilineTextAlignment(.center).padding(.horizontal, 32)
                    }
            }.padding(.top, -16)
            Spacer()
            HStack(spacing: 12) {
                btnTextGradientInfinity(
                    action: { viewModel.backQuestion() },
                    text: StringKey.back
                )
                .disabled(viewModel.questionNumber == 1)
                .opacity(viewModel.questionNumber == 1 ? 0.5 : 1)

                // Sonraki / Bitir
                btnTextGradientInfinity(
                    action: { viewModel.nextQuestion() },
                    text: viewModel.questionNumber == viewModel.lastQuestionNumber
                          ? QuestionStringKeys.finish
                          : QuestionStringKeys.next
                )
            }
            .padding(.horizontal)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showTimeSheet) {
            VStack(spacing: 24) {
                Text(QuestionStringKeys.question_time).font(.headline)

                // Slider 10-120 arası, 5’er adımlı
                Slider(value: Binding(
                    get:   { Double(defaultTime) },
                    set:   { defaultTime = Int($0) }
                ), in: 10...120, step: 5)
                Text(String(format: NSLocalizedString("set_second", comment: ""), defaultTime))

                Button(StringKey.save) {
                    viewModel.updateDefaultTime(to: defaultTime)
                    showTimeSheet = false
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .presentationDetents([.medium])

        }
        .padding()
    }
}

#Preview {
    OfflineQuestionUI(questionType: .catch_pair).environmentObject(RouterFeed())
}
