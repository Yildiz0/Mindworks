//
//  ContentView.swift
//  Fireflies
//
//  Created by Sena Yıldız on 13.11.2025.
//

import SwiftUI

struct FirefliesUI: View {
    
    @StateObject private var vm = FirefliesGameViewModel()
    @EnvironmentObject var router: RouterFeed
    
    @State private var showStatsPopup: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                // Top info
                VStack(spacing: 6) {
                    Text("Fireflies")
                        .font(.headline)
                    
                    Text("Level: \(vm.level) fireflies")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Highest Level Reached: \(vm.maxLevelReached)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Score: \(vm.score)")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
                .padding(.top, 24)
                
                // Card
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [Color.orange, Color(red: 1.0, green: 0.6, blue: 0.2)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    VStack(spacing: 6) {
                        Text(cardTitle)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        if !cardSubtitle.isEmpty {
                            Text(cardSubtitle)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                }
                .frame(height: 130)
                .padding(.horizontal)
                
                Spacer(minLength: 8)
                
                // Grid or big score
                if vm.phase == .gameOver {
                    gameOverScoreView
                        .padding(.horizontal)
                } else {
                    firefliesGrid
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Bottom buttons
                if vm.phase == .result {
                    resultButtons
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                } else {
                    mainButton
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                }
            }
            
            // ✅ Popup overlay
            if showStatsPopup {
                statsPopup
            }
        }
        .onChange(of: vm.phase) { newPhase in
            showStatsPopup = (newPhase == .gameOver)
        }
    }
    
    // MARK: - Titles
    
    private var cardTitle: String {
        switch vm.phase {
        case .idle:
            return "Get Ready"
        case .showingSequence:
            return "Watch the Fireflies"
        case .waitingForInput:
            return "Repeat the Sequence"
        case .result:
            return vm.lastRoundCorrect ? "Well Done!" : "Round Result"
        case .gameOver:
            return "Game Over"
        }
    }
    
    private var cardSubtitle: String {
        switch vm.phase {
        case .idle:
            return "You will see a sequence of fireflies lighting up.\nMemorize the lighting order.\nYou have two attempts to repeat it correctly."
        case .showingSequence:
            return ""
        case .waitingForInput:
            if vm.attemptsThisRound == 0 {
                return "Tap the fireflies in the same order. You have 2 attempts."
            } else {
                return "This is your second attempt. Make it count!"
            }
        case .result:
            return vm.feedbackMessage
        case .gameOver:
            return "Highest level: \(vm.maxLevelReached) • Current level: \(vm.level)"
        }
    }
    
    // MARK: - Game Over Score View
    
    private var gameOverScoreView: some View {
        VStack(spacing: 16) {
            Text("Final Score")
                .font(.title2.weight(.semibold))
                .foregroundColor(.orange)
            
            Text("\(vm.score)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.orange)
                .shadow(radius: 4)
            
            Text("Each successful sequence increases your score.\nTry to reach higher levels and finish rounds on the first attempt!")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Grid
    
    private var firefliesGrid: some View {
        VStack(spacing: 24) {
            if !gridStatusText.isEmpty {
                Text(gridStatusText)
                    .foregroundColor(.secondary)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 4), spacing: 20) {
                ForEach(0..<vm.fireflyCount, id: \.self) { index in
                    let isHighlighted = vm.highlightedIndex == index
                    let tapIndex = vm.userSequence.firstIndex(of: index)
                    
                    FireflyIcon(
                        isLit: isHighlighted,
                        tapOrder: (vm.phase == .waitingForInput ? tapIndex.map { $0 + 1 } : nil)
                    )
                    .onTapGesture {
                        vm.fireflyTapped(index: index)
                    }
                }
            }
        }
    }
    
    private var gridStatusText: String {
        switch vm.phase {
        case .showingSequence:
            return ""
        case .waitingForInput:
            let attemptText = vm.attemptsThisRound == 0 ? "Attempt 1 of 2" : "Attempt 2 of 2"
            return "\(attemptText) • Your taps: \(vm.userSequence.count)/\(vm.sequence.count)"
        case .result:
            return "Round finished."
        case .idle:
            return "Tap “Start Sequence” to begin."
        case .gameOver:
            return "Game finished. You can restart anytime."
        }
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
        .disabled(vm.phase == .showingSequence)
        .opacity(vm.phase == .showingSequence ? 0.7 : 1.0)
    }
    
    private var mainButtonTitle: String {
        switch vm.phase {
        case .idle:
            return "Start Sequence"
        case .showingSequence:
            return "Showing Sequence..."
        case .waitingForInput:
            return vm.userSequence.count == vm.sequence.count ? "Check Answer" : "Select Fireflies"
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
    
    // MARK: - Popup (Statistics)
    
    private var statsPopup: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture { }
            
            VStack(spacing: 18) {
                Text("İstatistikler")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.black)
                
                VStack(spacing: 14) {
                    Text("Doğru: \(vm.correctCount)")
                    Text("Yanlış: \(vm.wrongCount)")
                    
                    Text("Ortalama cevap: \(formatSeconds(vm.averageAnswerTime)) sn")
                    
                    Text("Doğruluk: \(formatPercent(vm.accuracyPercent))")
                }
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.black.opacity(0.85))
                
                VStack(spacing: 12) {
                    Button {
                        // Eğer router ile ana ekrana dönmek istiyorsan burayı kendi RouterFeed fonksiyonuna bağla:
                        // router.goHome()
                        
                        showStatsPopup = false
                        vm.restartFromPopup()
                    } label: {
                        Text("Ana ekran")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white.opacity(0.85))
                            .cornerRadius(18)
                    }
                    
                    Button {
                        showStatsPopup = false
                        vm.restartFromPopup()
                    } label: {
                        Text("Yeniden oyna")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.blue)
                            .cornerRadius(18)
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 22)
            .frame(maxWidth: 340)
            .background(.ultraThinMaterial)
            .cornerRadius(26)
            .shadow(radius: 18)
        }
    }
    
    private func formatSeconds(_ value: TimeInterval) -> String {
        let nf = NumberFormatter()
        nf.locale = Locale(identifier: "tr_TR")
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf.string(from: NSNumber(value: value)) ?? "0,00"
    }
    
    private func formatPercent(_ value: Double) -> String {
        let nf = NumberFormatter()
        nf.locale = Locale(identifier: "tr_TR")
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        let s = nf.string(from: NSNumber(value: value)) ?? "0,00"
        return "%\(s)"
    }
}

struct FirefliesGameView_Previews: PreviewProvider {
    static var previews: some View {
        FirefliesUI()
    }
}
