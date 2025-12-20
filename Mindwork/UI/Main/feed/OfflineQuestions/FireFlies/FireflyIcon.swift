//
//  FireflyIcon.swift
//  Fireflies
//
//  Created by Sena Yıldız on 14.11.2025.
//
import SwiftUI

struct FireflyIcon: View {
    let isLit: Bool
    let tapOrder: Int?
    
    var body: some View {
        ZStack {
            // Glow
            if isLit {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.2)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 40
                        )
                    )
                    .blur(radius: 1.5)
            }
            
            // Firefly body
            VStack(spacing: 2) {
                // Wings
                HStack(spacing: 4) {
                    Capsule()
                        .fill(Color.cyan.opacity(isLit ? 0.9 : 0.4))
                        .frame(width: 16, height: 8)
                    Capsule()
                        .fill(Color.cyan.opacity(isLit ? 0.9 : 0.4))
                        .frame(width: 16, height: 8)
                }
                // Head
                Circle()
                    .fill(Color.black.opacity(0.8))
                    .frame(width: 12, height: 12)
                    .overlay(
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.white.opacity(0.9))
                                .frame(width: 3, height: 3)
                            Circle()
                                .fill(Color.white.opacity(0.9))
                                .frame(width: 3, height: 3)
                        }
                        .offset(y: 1)
                    )
                // Body
                RoundedRectangle(cornerRadius: 12)
                    .fill(isLit ? Color.yellow : Color.gray.opacity(0.4))
                    .frame(width: 26, height: 30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(isLit ? 0.8 : 0.4), lineWidth: isLit ? 2 : 0.8)
                    )
            }
            
            // Tap order number
            if let tapOrder = tapOrder {
                Text("\(tapOrder)")
                    .font(.caption.bold())
                    .foregroundColor(.purple)
                    .padding(4)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
                    .offset(y: -24)
            }
        }
        .frame(width: 70, height: 70)
    }
}

