//
//  FeedUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 23.01.2025.
//

import SwiftUI

struct FeedUI: View {
    @EnvironmentObject var routerFeed: RouterFeed
    @StateObject var viewModel = FeedViewModel()
    @State private var selectedQuestionType: QuestionType?
    
    var body: some View {
        ZStack(alignment: .top) {
            DownSizedImageView(image: UIImage(named: "palmiye"),
                               size: CGSize(width: 200, height: 200)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            }.frame(maxWidth: .infinity, alignment: .topTrailing)
                               .offset(x: 24, y: 20)
                               .zIndex(0.9)
            
            DownSizedImageView(image: UIImage(named: "palmiye"),
                               size: CGSize(width: 140, height: 140)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)
            }.frame(maxWidth: .infinity, alignment: .topLeading)
                               .offset(x: 24, y: 60)
                               .zIndex(0.9)
            
            ScrollView{
                // Subjects bölümü
                SubjectsView(title: QuestionStringKeys.memory_title, description: QuestionStringKeys.memory_description).frame(maxWidth: .infinity,alignment: .leading)
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 16){
                        ForEach(viewModel.questionList){ question in
                            Button {
                                navigateGame(type: question.questionType)
                            } label: {
                                FeedRowUI(foregroundColor: question.foregroundColor, backgroundColor: question.backgroundColor, title: Text(question.title)).frame(width: Width.screenFourtyTwoWidth)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }.padding(.bottom)
                // Games bölümü
                SubjectsView(title: QuestionStringKeys.focus_title, description: QuestionStringKeys.focus_description).frame(maxWidth: .infinity,alignment: .leading)
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 16){
                        ForEach(viewModel.gameList){ game in
                            Button {
                                navigateGame(type: game.questionType)
                            } label: {
                                FeedRowUI(foregroundColor: game.foregroundColor, backgroundColor: game.backgroundColor, title: Text(game.title)).frame(width: Width.screenFourtyTwoWidth)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                SubjectsView(title: QuestionStringKeys.place_time_title, description: QuestionStringKeys.place_time_description).frame(maxWidth: .infinity,alignment: .leading)
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 16){
                        ForEach(viewModel.gameList){ game in
                            Button {
                                navigateGame(type: game.questionType)
                            } label: {
                                FeedRowUI(foregroundColor: game.foregroundColor, backgroundColor: game.backgroundColor, title: Text(game.title)).frame(width: Width.screenFourtyTwoWidth)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }.padding(.bottom,140)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.leading,16).padding(.top)
                .background(Color.white).clipShape(RoundedTopLeftShape(radius: 70)).padding(.top,190)
                .zIndex(1)
            /* Online
                .customAlert(titleKey: QuestionStringKeys.question_select_title,
                             descriptionKey: QuestionStringKeys.question_select_description,
                             isPresented: $showAlert,
                             acceptText: QuestionStringKeys.question_select_online,
                             deniedText: QuestionStringKeys.question_select_offline,
                             acceptFunc: {
                    if let type = selectedQuestionType {
                        routerFeed.navigate(to: .colorful_words)
                    }
                },
                             deniedFunc: {
                    if let type = selectedQuestionType {
                        switch selectedQuestionType {
                        case .was_it_there:
                            routerFeed.navigate(to: .colorful_words)
                        case .which_different:
                            routerFeed.navigate(to: .colorful_words)
                        case .colorful_words:
                            routerFeed.navigate(to: .colorful_words)
                        case .catch_pair:
                            routerFeed.navigate(to: .colorful_words)
                        case .firefly_title:
                            routerFeed.navigate(to: .colorful_words)
                        case nil:
                            routerFeed.navigate(to: .colorful_words)
                        }
                    }
                })*/
        }.ignoresSafeArea().background(Color.feedBackground.opacity(0.8))
    }
    
    private func navigateGame(type: QuestionType?) {
        switch type {
        case .was_it_there:
            routerFeed.navigate(to: .was_it_there)
        case .which_different:
            routerFeed.navigate(to: .which_different)
        case .colorful_words:
            routerFeed.navigate(to: .colorful_words)
        case .catch_pair:
            routerFeed.navigate(to: .catch_pair)
        case .firefly_title:
            routerFeed.navigate(to: .firefly_title)
        case .reflexGame:
            routerFeed.navigate(to: .reflex)
        case .wordCube:
            routerFeed.navigate(to: .word_cube)
        case .timing:
            routerFeed.navigate(to: .timing)
        case .none:
            routerFeed.navigate(to: .colorful_words)
        }
    }
}

struct SubjectsView: View {
    var title: LocalizedStringKey
    var description: LocalizedStringKey
    
    var body: some View {
        VStack(alignment: .leading){
            tvSubtitleFont(text: title, color: .blue)
            tvBodyline(text: description, color: .gray).truncationMode(.head)
        }
    }
}

#Preview {
    FeedUI()
}
