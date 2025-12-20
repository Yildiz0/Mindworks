import SwiftUI

struct FindColorUI: View {
    @StateObject var viewModel = FindColorViewModel()
    @EnvironmentObject var router: RouterFeed
    @State private var showTimeSheet = false

    // 4 buton için akıcı offset'ler
    @State private var offsets: [CGSize] = Array(repeating: .zero, count: 4)

    var body: some View {
        VStack{
            HStack{
                btnSystemIconTransparent(iconSystemName: Icons.left_direction, color: .black) {
                    router.navigateBack()
                }
                Spacer()
                tvBodylineString(
                    text: String(format: NSLocalizedString("question_number", comment: ""), viewModel.questionNumber),
                    color: .black
                )
                Spacer()
                btnSystemIconTransparent(iconSystemName: "ellipsis.circle", color: .black) {
                    showTimeSheet = true
                }
            }

            ProgressView(value: viewModel.questionProgress)
                .padding(.top)
                .tint(.orange300)
                .scaleEffect(x: 1,y: 2, anchor: .center)

            tvBodylineString(text: String(format: "%.2f", viewModel.timeCounter), color: .black).padding(.top)
            tvBodyline(text: QuestionStringKeys.think_question, color: .gray)

            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.orange)
                .overlay {
                    tvBodyline(text: viewModel.questionTitle, color: .white).padding(8)
                }
                .frame(maxWidth: 500, maxHeight: 100)
                .padding(.horizontal, 24)
                .background(Color.clear)
                .padding(.top, 32)

            VStack{
                Spacer()
                Spacer()
                HStack {
                    Spacer()
                    ColorAnswerButton(
                        title: viewModel.optionOne?.optionText ?? StringKey.accept,
                        color: viewModel.optionOne?.optionColor ?? .blue
                    ) { viewModel.checkQuestion(selectedAnswer: 0) }
                    .offset(offsets[0])
                    .disabled(viewModel.answeredQuestion)
                    Spacer()

                    ColorAnswerButton(
                        title: viewModel.optionTwo?.optionText ?? StringKey.accept,
                        color: viewModel.optionTwo?.optionColor ?? .blue
                    ) { viewModel.checkQuestion(selectedAnswer: 1) }
                    .offset(offsets[1])
                    .disabled(viewModel.answeredQuestion)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    ColorAnswerButton(
                        title: viewModel.optionThree?.optionText ?? StringKey.accept,
                        color: viewModel.optionThree?.optionColor ?? .blue
                    ) { viewModel.checkQuestion(selectedAnswer: 2) }
                    .offset(offsets[2])
                    .disabled(viewModel.answeredQuestion)

                    Spacer()

                    ColorAnswerButton(
                        title: viewModel.optionFour?.optionText ?? StringKey.accept,
                        color: viewModel.optionFour?.optionColor ?? .blue
                    ) { viewModel.checkQuestion(selectedAnswer: 3)
                    }
                    .offset(offsets[3])
                    .disabled(viewModel.answeredQuestion)
                    Spacer()
                }
                Spacer()
                Spacer()
            }.frame(maxHeight: .infinity).background(Color.gray.opacity(0.04)).cornerRadius(16)
            btnTextGradientInfinity(
                action: { viewModel.nextQuestion() },
                text: viewModel.questionNumber == viewModel.lastQuestionNumber
                    ? QuestionStringKeys.finish
                    : (viewModel.answeredQuestion
                        ? (viewModel.isAnswerTrue ? StringKey.true_answer : StringKey.wrong_answer)
                        : QuestionStringKeys.next)
            ).disabled(!viewModel.answeredQuestion).opacity(!viewModel.answeredQuestion ? 0.6 : 1.0)
            .padding(.horizontal, 64)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showTimeSheet) {
            VStack(spacing: 24) {
                Text(QuestionStringKeys.question_time).font(.headline)
                Button(StringKey.save) { showTimeSheet = false }
                    .buttonStyle(.borderedProminent)
            }
            .padding()
            .presentationDetents([.medium])
        }
        .padding()
        // EKRANA GELİNCE ilk konumları ata
        .onAppear { updateOffsets(animated: false) }
        // HER SANİYE artan sayaç değiştikçe akıcı hareket et
        .onChange(of: viewModel.uiTick) { oldValue, newValue in
            updateOffsets(animated: true)
        }.customAnswerAlert(
            isPresented: $viewModel.gameOver,
            titleKey: StatsKey.title,
            trueCount: StatsKey.trueCount(viewModel.correctCount),
            wrongCount: StatsKey.wrongCount(viewModel.wrongCount),
            averageAnswer: StatsKey.averageAnswer(seconds: viewModel.averageResponseTime),
            accuracy: StatsKey.accuracy(percent: viewModel.percentageTruth),
            acceptText: StringKey.start_again,
            deniedText: StringKey.main_page,
                      acceptFunc: {
            viewModel.startAgain()
         },
                      deniedFunc: {
            router.navigateBack()
         })
    }

    // MARK: - Offset üretimi
    private func updateOffsets(animated: Bool) {
        let new = (0..<4).map { _ in randomOffset() }
        if animated {
            withAnimation(.easeInOut(duration: 0.9)) { // 1 sn'lik tick için akıcı
                offsets = new
            }
        } else {
            offsets = new
        }
    }

    private func randomOffset() -> CGSize {
        CGSize(width: CGFloat(Int.random(in: -20...20)),
               height: CGFloat(Int.random(in: -20...20)))
    }
}

#Preview {
    FindColorUI().environmentObject(RouterFeed())
}
