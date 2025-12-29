//
//  ReverseWordUI.swift
//  Mindwork
//
//  Created by Sena Yıldız on 21.12.2025.
//

import SwiftUI

struct ReverseWordUI: View {

    @StateObject private var vm = ReverseWordViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 18) {

                // Header
                VStack(spacing: 6) {
                    Text("Reverse Word")
                        .font(.system(size: 40, weight: .bold))

                    Text("Level: \(vm.levelLength) letters")
                        .font(.system(size: 22))
                        .foregroundStyle(.gray)

                    Text("Score: \(vm.score)")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.orange)
                }
                .padding(.top, 10)

                // ✅ Time label (total time)
                Text(vm.totalTimeText)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.gray.opacity(0.75))
                    .padding(.top, 2)

                // ✅ Progress bar -> now shows TIME progress (visual)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.25))
                            .frame(height: 6)

                        Capsule()
                            .fill(Color.orange.opacity(0.95))
                            .frame(width: max(10, geo.size.width * vm.timeProgress), height: 6)
                    }
                }
                .frame(height: 6)
                .padding(.horizontal, 22)

                // Main Card
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.orange.opacity(0.95),
                                    Color.orange.opacity(0.65)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 360)
                        .padding(.horizontal, 20)

                    VStack(spacing: 18) {

                        if vm.phase == .ready {
                            Text("Get Ready")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(.white)

                            Text("You will see a word briefly. Then type it backwards.")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.white.opacity(0.95))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }

                        if vm.phase == .showingWord {
                            Text("Memorize This Word")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(.white)

                            Text(vm.currentWord)
                                .font(.system(size: 52, weight: .heavy))
                                .foregroundStyle(.white)
                                .padding(.top, 8)
                        }

                        if vm.phase == .typing || vm.phase == .feedback {
                            Text("Now Type It Backwards")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundStyle(.white)

                            TextField("Type the reversed word...", text: $vm.userInput)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 14)
                                .background(Color.white.opacity(0.95))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .padding(.horizontal, 26)
                                .disabled(vm.phase == .feedback)

                            if vm.phase == .feedback {
                                Text(vm.feedbackText)
                                    .font(.system(size: 26, weight: .heavy))
                                    .foregroundStyle(vm.feedbackColor)
                                    .shadow(color: Color.black.opacity(0.20), radius: 1, x: 0, y: 1)

                                if let p = vm.lastRoundPoints {
                                    Text(p > 0 ? "+\(p)" : "+0")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundStyle(.white.opacity(0.98))
                                        .padding(.top, -6)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }

                Spacer()

                Text(bottomHint)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.gray.opacity(0.7))
                    .padding(.bottom, 6)

                Button(action: bottomButtonAction) {
                    Text(bottomButtonTitle)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.orange.opacity(0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
                        .padding(.horizontal, 20)
                }
                .padding(.bottom, 18)
                .disabled(isBottomButtonDisabled)

            }
            .padding(.top, 6)

            // ✅ Game Over Popup
            if vm.isStatsPopupPresented {
                StatsPopupView(
                    correct: vm.correctCount,
                    wrong: vm.wrongCount,
                    averageSeconds: vm.averageAnswerSeconds,
                    accuracy: vm.accuracyPercent,
                    onMain: { vm.goToMain() },
                    onRestart: { vm.restartGame() }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.18), value: vm.isStatsPopupPresented)
    }

    private var bottomButtonTitle: String {
        switch vm.phase {
        case .ready: return "Start Round"
        case .showingWord: return "..."
        case .typing: return "Submit"
        case .feedback: return "Next"
        case .gameOver: return "..."
        }
    }

    private var bottomHint: String {
        switch vm.phase {
        case .ready:
            return "Tap the button below to start the round."
        case .showingWord:
            return "Look carefully..."
        case .typing:
            return "Type it backwards, then submit."
        case .feedback:
            return "Tap the button below to continue."
        case .gameOver:
            return ""
        }
    }

    private var isBottomButtonDisabled: Bool {
        if vm.phase == .showingWord { return true }
        if vm.phase == .gameOver { return true }
        if vm.phase == .typing {
            return vm.userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return false
    }

    private func bottomButtonAction() {
        switch vm.phase {
        case .ready:
            vm.startRound()
        case .showingWord:
            break
        case .typing:
            vm.submit()
        case .feedback:
            vm.nextRound()
        case .gameOver:
            break
        }
    }
}

// MARK: - Popup View (UI)
private struct StatsPopupView: View {

    let correct: Int
    let wrong: Int
    let averageSeconds: Double
    let accuracy: Double

    let onMain: () -> Void
    let onRestart: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("İstatistikler")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.black)

                VStack(spacing: 14) {
                    Text("Doğru: \(correct)")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.black)

                    Text("Yanlış: \(wrong)")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.black)

                    Text("Ortalama cevap: \(formatSeconds(averageSeconds)) sn")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.black)

                    Text("Doğruluk: \(formatPercent(accuracy))")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(.black)
                }
                .padding(.top, 6)

                VStack(spacing: 12) {
                    Button(action: onMain) {
                        Text("Ana ekran")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.white.opacity(0.7))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }

                    Button(action: onRestart) {
                        Text("Yeniden oyna")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.blue.opacity(0.95))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 22)
            .frame(maxWidth: 340)
            .background(Color(white: 0.86).opacity(0.95))
            .clipShape(RoundedRectangle(cornerRadius: 28))
        }
    }

    private func formatSeconds(_ s: Double) -> String {
        // "4,25" gibi TR format hissi için:
        let formatted = String(format: "%.2f", s)
        return formatted.replacingOccurrences(of: ".", with: ",")
    }

    private func formatPercent(_ p: Double) -> String {
        let formatted = String(format: "%.2f%%", p)
        return formatted.replacingOccurrences(of: ".", with: ",")
    }
}

#Preview {
    ReverseWordUI()
}
