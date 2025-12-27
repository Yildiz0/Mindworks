//
//  ContentView.swift
//  WordCube
//
//  Created by Sena Yıldız on 13.11.2025.
//
//
import SwiftUI

struct WordCubeUI: View {

    @StateObject private var vm = WordCubeGameViewModel()
    @EnvironmentObject var router: RouterFeed

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {

                // Top bar
                VStack(spacing: 6) {
                    Text("Word Cube")
                        .font(.headline)

                    Text("Level: \(vm.level) words")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Score: \(vm.score)")
                        .font(.subheadline)
                        .foregroundColor(.orange)

                    ProgressView(
                        value: Double(vm.level - vm.minLevel + 1),
                        total: Double(vm.maxLevel - vm.minLevel + 1)
                    )
                    .tint(.orange)
                    .padding(.horizontal)

                    Text(String(format: "%.2f", vm.elapsedTime))
                        .font(.title3.monospacedDigit())
                        .foregroundColor(.primary)
                }
                .padding(.top, 24)

                // Question area
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color.orange, Color(red: 1.0, green: 0.6, blue: 0.2)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    VStack(spacing: 8) {
                        Text(questionTitle)
                            .font(.headline)
                            .foregroundColor(.white)

                        // ✅ Subtitle rules updated exactly as you asked
                        switch vmPhase {
                        case .idle:
                            Text("You will see \(vm.level) words one by one on the screen.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))

                            Text("Try to memorize the words in the correct order.")
                                .font(.subheadline.bold())
                                .foregroundColor(.white)

                        case .showingWords:
                            // Keep only "Watch the Words", remove subtitle
                            EmptyView()

                        case .recalling:
                            Text("Type the words in the exact order you saw them.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))

                        case .result:
                            Text(vm.feedbackMessage)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))

                        case .gameOver:
                            Text(vm.feedbackMessage)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                }
                .frame(height: 110)
                .padding(.horizontal)

                Spacer(minLength: 8)

                // Main content area (changes with phase)
                Group {
                    switch vmPhase {
                    case .idle, .showingWords:
                        showingWordsView
                    case .recalling:
                        recallView
                    case .result:
                        resultView
                    case .gameOver:
                        // ✅ Oyun ekranı arkada kalsın (popup üstte gelecek)
                        resultView
                    }
                }
                .padding(.horizontal)

                Spacer()

                // Bottom buttons
                if vmPhase == .result {
                    resultButtons
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                } else if vmPhase != .gameOver {
                    mainButton
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                }
            }
        }
        // ✅ POPUP ARTIK GERÇEK OVERLAY (tam ekran üstüne biner)
        .overlay {
            if vm.showStatsPopup {
                statsPopupOverlay
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: vm.showStatsPopup)
    }

    // Convenience
    private var vmPhase: WordCubeGameModel.Phase { vm.phase }

    // MARK: - Titles

    private var questionTitle: String {
        switch vmPhase {
        case .showingWords:
            return "Watch the Words"
        case .recalling:
            return "Write the Words"
        case .result:
            return "Round Result"
        case .gameOver:
            return "Game Over"
        case .idle:
            return "Get Ready"
        }
    }

    // MARK: - Subviews

    private var showingWordsView: some View {
        VStack(spacing: 16) {
            if vmPhase == .showingWords {
                Text(vm.displayedWord)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.purple)
                    .animation(.easeInOut, value: vm.displayedWord)

                Text("Words are being shown...")
                    .foregroundColor(.secondary)
            } else {
                Text("Tap the button below to start the round.")
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var recallView: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Type the \(vm.level) words you saw, in the correct order.")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(0..<vm.userInputs.count, id: \.self) { index in
                    HStack {
                        Text("\(index + 1).")
                            .frame(width: 24, alignment: .leading)
                            .foregroundColor(.secondary)

                        TextField("Word \(index + 1)", text: Binding(
                            get: { vm.userInputs[index] },
                            set: { vm.userInputs[index] = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    }
                }
            }
        }
    }

    private var resultView: some View {
        VStack(spacing: 16) {
            Text("Correct: \(vm.lastCorrectCount) / \(vm.currentWords.count)")
                .font(.title3)

            VStack(alignment: .leading, spacing: 4) {
                Text("Correct order:")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(vm.currentWords.joined(separator: " • "))
                    .font(.body)
                    .foregroundColor(.purple)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
    }

    // ✅ POPUP OVERLAY (tam ekran)
    private var statsPopupOverlay: some View {
        ZStack {
            // arkaplan karartı
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture {
                    // İstersen tıklayınca kapatmayı istemiyorsun diye dokunmuyorum.
                    // vm.showStatsPopup = false  (istersen açarız)
                }

            // popup kart
            VStack(spacing: 16) {
                Text("İstatistikler")
                    .font(.title2.bold())

                VStack(spacing: 12) {
                    statRow(title: "Doğru", value: "\(vm.totalCorrect)")
                    statRow(title: "Yanlış", value: "\(vm.totalWrong)")
                    statRow(title: "Ortalama cevap", value: String(format: "%.2f sn", vm.averageResponseTime))
                    statRow(title: "Doğruluk", value: String(format: "%.2f%%", vm.accuracyRate * 100))
                }
                .padding(.vertical, 8)

                Button(action: { router.navigateToRoot() }) {
                    Text("Ana ekran")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(20)
                }

                Button(action: { vm.restartGameTapped() }) {
                    Text("Yeniden oyna")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.systemGray5))
            )
            .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Buttons

    private var mainButton: some View {
        Button(action: { vm.mainButtonTapped() }) {
            Text(mainButtonTitle)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [Color.orange, Color(red: 1.0, green: 0.5, blue: 0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                .shadow(radius: 4, y: 2)
        }
        .disabled(vmPhase == .showingWords)
        .opacity(vmPhase == .showingWords ? 0.7 : 1.0)
    }

    private var mainButtonTitle: String {
        switch vmPhase {
        case .idle:
            return "Start Round"
        case .showingWords:
            return "Showing Words..."
        case .recalling:
            return "Check Answers"
        case .result:
            return "Next Round"
        case .gameOver:
            return "Restart Game"
        }
    }

    private var resultButtons: some View {
        HStack(spacing: 12) {
            Button(action: { vm.endGameTapped() }) {
                Text("End Game")
                    .font(.headline)
                    .foregroundColor(.orange)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.orange, lineWidth: 2)
                    )
            }

            Button(action: { vm.nextRoundTapped() }) {
                Text("Next Round")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [Color.orange, Color(red: 1.0, green: 0.5, blue: 0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(radius: 4, y: 2)
            }
        }
    }

    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text("\(title):")
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .foregroundColor(.primary)
        }
    }
}

struct WordCubeGameView_Previews: PreviewProvider {
    static var previews: some View {
        WordCubeUI()
    }
}
