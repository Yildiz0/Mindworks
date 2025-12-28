//
//  TimingGameUI.swift
//  Mindwork
//
//  Created by Cemre Bayer on 28.12.2025.
//

import SwiftUI

struct TimingGameUI: View {
    @StateObject var viewModel = TimingGameViewModel()
    @EnvironmentObject var router: RouterFeed // Kendi router isminle değiştir (RouterFeed/MockRouter)

    var body: some View {
        VStack {
            // MARK: - Header (FindColor stili)
            HStack {
                btnSystemIconTransparent(iconSystemName: Icons.left_direction, color: .black) {
                    router.navigateBack()
                }
                Spacer()
                tvBodylineString(
                    text: "Seviye: \(viewModel.level)",
                    color: .black
                )
                Spacer()
                tvBodylineString(
                    text: "Skor: \(viewModel.score)",
                    color: .black
                )
            }
            .padding(.horizontal)

            Spacer()

            // MARK: - Oyun Alanı
            VStack(spacing: 40) {
                // Bilgi metni
                tvBodylineString(text: "Tam ortada durdur!", color: .gray)

                ZStack {
                    // Arka plan çizgisi (Gri temizlendi/Modernleşti)
                    Capsule()
                        .fill(Color.black.opacity(0.1))
                        .frame(height: 8)
                    
                    // Hedef noktası (Turuncu çizgi)
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: 4, height: 40)
                    
                    // Hareket eden top
                    GeometryReader { geo in
                        Circle()
                            .fill(viewModel.gameResult?.color ?? .blue)
                            .frame(width: 32, height: 32)
                            .shadow(radius: 4)
                            .offset(x: (geo.size.width - 32) * viewModel.barPosition)
                    }
                    .frame(height: 32)
                }
                .padding(.horizontal, 40)
                
                // Sonuç Metni
                if let result = viewModel.gameResult {
                    Text(result.rawValue)
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(result.color)
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text(" ") // Layout bozulmasın diye boş alan
                        .font(.largeTitle)
                }
            }

            Spacer()

            // MARK: - Kontrol Butonu (Tendria Degrade Stili)
            btnTextGradientInfinity(
                action: { viewModel.stopAndCheck() },
                text: "DURDUR"
            )
            .disabled(viewModel.gameResult != nil)
            .opacity(viewModel.gameResult != nil ? 0.6 : 1.0)
            .padding(.horizontal, 64)
            .padding(.bottom, 32)
        }
        .navigationBarHidden(true)
        // MARK: - Kurumsal Alert Yapısı
        .customAnswerAlert(
            isPresented: $viewModel.gameOver,
            titleKey: "Oyun Bitti!",
            trueCount: "Başarılı Hamle: \(viewModel.correctCount)",
            wrongCount: "Kaçırma: \(viewModel.wrongCount)",
            averageAnswer: "Toplam Skor: \(viewModel.score)",
            accuracy: "Doğruluk: %\(Int(viewModel.percentageTruth))",
            acceptText: "Tekrar Oyna",
            deniedText: "Ana Menü",
            acceptFunc: { viewModel.resetGame() },
            deniedFunc: { router.navigateBack() }
        )
    }
}
