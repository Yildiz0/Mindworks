import SwiftUI

struct CatchPairUI: View {
    @StateObject var viewModel = CatchPairViewModel()
    @EnvironmentObject var router: RouterFeed
    @State private var showTimeSheet = false

    // 4 buton için akıcı offset'ler
    @State private var offsets: [CGSize] = Array(repeating: .zero, count: 4)
    @State private var selectedNumber: Int = 0
    
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
            if viewModel.preparingGame {
                tvBodyline(text: StringKey.showing_numbers, color: .gray)
            }
            if let isTrue = viewModel.isTrue {
                tvBodyline(text: isTrue ? StringKey.true_answer : StringKey.wrong_answer, color: isTrue ? .green : .red)
            }
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.orange)
                .overlay {
                    tvBodyline(text: viewModel.questionTitle, color: .white).padding(8)
                }
                .frame(maxWidth: 500, maxHeight: 100)
                .padding(.horizontal, 24)
                .background(Color.clear)
                .padding(.top, 32)

            // ✅ Turuncu "Başlat" butonu KALDIRILDI (başka hiçbir şey değişmedi)

            VStack{
                Spacer()
                ColorAnswerButton(
                    title: viewModel.currentNumber,
                    color: viewModel.randomColor
                ) {
                    if viewModel.waitingToStart {
                        viewModel.startGame()
                    } else {
                        viewModel.checkQuestion(selectedNumber: 0)
                    }
                }
                .offset(offsets[0])
                .disabled(viewModel.answeredQuestion && !viewModel.waitingToStart)
                Spacer()
            }.frame(maxWidth: .infinity,maxHeight: .infinity).background(Color.gray.opacity(0.04)).cornerRadius(16)
            
            keyboards.disabled(viewModel.answeredQuestion).opacity(!viewModel.answeredQuestion ? 1.0 : 0.6)
            
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
            }
        )
    }
    
    private var keyboards: some View {
        let buttons = [[1,2,3],[4,5,6],[7,8,9]]
        return VStack{
            Grid(horizontalSpacing: 20,verticalSpacing: 15) {
                ForEach(0..<buttons.count, id: \.self) {rowIndex in
                    GridRow {
                        ForEach(buttons[rowIndex], id: \.self) { number in
                            KeypadButton(label: number) {
                                viewModel.checkQuestion(selectedNumber: number)
                            }
                        }
                    }
                }
                GridRow {
                    KeypadButton(label: 0) {
                        viewModel.checkQuestion(selectedNumber: 0)
                    }
                    .gridCellColumns(2)
                    .gridCellAnchor(.trailing)
                }
            }
            
        }
    }

    struct KeypadButton: View {
        let label: Int
        let action: () -> Void
        var body: some View {
            Button {
                action()
            } label: {
                Text(String(label)).font(.largeTitle).frame(width: 50,height: 50)
                    .background(Color.gray.opacity(0.2), in: Circle())
            }.tint(.primary)
        }
    }

    struct TextButton: View {
        let label: String
        let action: () -> Void
        var body: some View {
            Button {
                action()
            } label: {
                Text(String(label)).font(.largeTitle).frame(width: 50,height: 50)
                    .background(Color.orange.opacity(0.1), in: Circle())
            }.tint(.primary)
        }
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
        CGSize(width: CGFloat(Int.random(in: -70...70)),
               height: CGFloat(Int.random(in: -70...70)))
    }
}

#Preview {
    CatchPairUI().environmentObject(RouterFeed())
}

