//
//  ContentView.swift
//  Reflex
//
//  Created by Sena Yıldız on 13.11.2025.
//

import SwiftUI

struct ReflexUI: View {
    
    @StateObject private var vm = ReflexGameViewModel()
    @EnvironmentObject var router: RouterFeed

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                VStack {
                    Text("🟢 Yeşil – 🟡 Sarı – 🔴 Kırmızı")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing))
                    
                    Text(vm.message)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                }
                .padding(.top)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(vm.currentColor.color)
                        .frame(width: 200, height: 200)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 8)
                        .onTapGesture {
                            vm.handleTap()
                        }
                        .animation(.easeInOut(duration: 0.2), value: vm.currentColor)
                    
                    if vm.showScoreDelta, let delta = vm.lastScoreDelta {
                        Text("+\(delta)")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                            .animation(.easeOut(duration: 0.2), value: vm.showScoreDelta)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    Text("Skor: \(vm.score)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Text("En İyi: \(vm.highScore)")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                if vm.gameState == .ready {
                    Button(action: { vm.startGame() }) {
                        Text("Başla")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal, 50)
                            .padding(.vertical, 15)
                            .background(
                                LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 8)
                    }
                    .padding(.bottom)
                } else if vm.gameState == .gameOver {
                    Button(action: { vm.startGame() }) {
                        Text("Tekrar Oyna")
                            .font(.title2)
                    }
                }
            }
            
        }
    }
}
