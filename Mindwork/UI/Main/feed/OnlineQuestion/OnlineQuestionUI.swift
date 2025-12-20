//
//  QuestionUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 30.07.2025.
//

import SwiftUI

struct OnlineQuestionUI: View {
    var questionType: QuestionType
    @StateObject var viewModel: OnlineQuestionViewModel
    @StateObject private var keyboardObserver = KeyboardObserver.shared
    @EnvironmentObject var router: RouterFeed
    @State private var showTimeSheet = false
    @AppStorage(Constants.UserDefaultsKeys.questionTime) private var defaultTime = 30
    @FocusState private var focusedField: OnlineState?
    @State private var showKeyboard = false

    init(questionType: QuestionType) {
        self.questionType = questionType
        _viewModel = StateObject(wrappedValue: OnlineQuestionViewModel(questionType: questionType))
    }
    
    var body: some View {
        VStack(){
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
            
            HStack(alignment: .top){
                ReadyAvatarView(imageURL: viewModel.secondUserImage, name: viewModel.secondUserName, isReady: $viewModel.secondUserReady)
                Spacer()
                
                Spacer()
                ReadyAvatarView(imageURL: viewModel.firstUserImage, name: viewModel.firstUserName, isReady: $viewModel.firstUserReady)
            }.padding(.top).overlay(alignment: .center) {
                VStack{
                    tvBodylineString(text: viewModel.isTimeOver ? "" : "\(viewModel.timeRemaining)", color: .black).padding(.top)
                    tvBodyline(text: viewModel.isTimeOver ? QuestionStringKeys.answer_question : QuestionStringKeys.think_question, color: .gray)
                }.padding(.top, -16)
            }
            
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.gray)
                    .overlay {
                        tvBodyline(text: viewModel.questionTitle, color: .black)
                    }
                    .frame(width: 200).frame(minHeight: 30, maxHeight: 60)
                    .background(Color.clear).offset(y: showKeyboard ? -50 : -100)
                    .animation(.easeInOut(duration: 0.15),
                               value: showKeyboard)
                    .zIndex(2.0)
                
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.orange)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity,minHeight: 90,maxHeight: 200)
                    .background(Color.clear)
                    .zIndex(1.9)
                    .overlay {
                        tvBodyline(text: viewModel.questionDescription, color: .black)
                            .multilineTextAlignment(.center).padding(.horizontal, 32)
                    }
            }.padding(.top, 64)
    
            teText(placeHolder: QuestionStringKeys.write_answer, textInput: $viewModel.firstUserAnswer).frame(height: Height.xxLargePlusHeight)
                .focused($focusedField, equals: .answer)
                .simultaneousGesture(
                    TapGesture().onEnded({ _ in
                        focusedField = nil
                    })
                ).padding(.top,32)
          
            btnTextGradientInfinity(
                action: { viewModel.answerQuestion() },
                text: viewModel.isAnswered
                      ? QuestionStringKeys.change_answer
                      : QuestionStringKeys.ready_answer
            )
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
        .onChange(of: focusedField) { newValue in
            if (newValue == nil){
                showKeyboard = false
            }else {
                showKeyboard = true
            }
        }
    }
    
    enum OnlineState: Hashable{
        case title
        case answer
    }
}

#Preview {
    OnlineQuestionUI(questionType: .catch_pair).environmentObject(RouterFeed())
}
