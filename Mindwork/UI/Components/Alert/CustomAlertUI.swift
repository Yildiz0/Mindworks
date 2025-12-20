//
//  CustomAlert.swift
//  Tendria
//
//  Created by Yakup Kavak on 04.08.2025.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var isPresented: Bool
    
    let titleKey:        LocalizedStringKey
    let descriptionKey:  LocalizedStringKey
    let acceptText:      LocalizedStringKey
    let deniedText:      LocalizedStringKey
    
    let acceptFunc: (() -> Void)?
    let deniedFunc: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Arka plan karartması + tıklanınca kapanma
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .contentShape(Rectangle()) // Tıklamayı algılat
                .onTapGesture {
                    isPresented = false
                }

            VStack(spacing: 20) {
                Text(titleKey)
                    .font(.title2).bold()
                    .multilineTextAlignment(.center)
                
                Text(descriptionKey)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                
                Button {
                    deniedFunc?()
                    isPresented = false
                } label: {
                    Text(deniedText)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                Button {
                    acceptFunc?()
                    isPresented = false
                } label: {
                    Text(acceptText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(28)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(.horizontal, 32)
        }
    }
}


extension View {
    func customAlert(
        titleKey:        LocalizedStringKey,
        descriptionKey:  LocalizedStringKey,
        isPresented:     Binding<Bool>,
        acceptText:      LocalizedStringKey,
        deniedText:      LocalizedStringKey,
        acceptFunc:      (() -> Void)?,
        deniedFunc:      (() -> Void)?
    ) -> some View {
        self.fullScreenCover(isPresented: isPresented) {
            CustomAlertView(
                isPresented:   isPresented,
                titleKey:      titleKey,
                descriptionKey:descriptionKey,
                acceptText:    acceptText,
                deniedText:    deniedText,
                acceptFunc:    acceptFunc,
                deniedFunc:    deniedFunc
            )
            .presentationBackground(.clear)   // Animasyonsuz şeffaf zemin
        }
    }
}

import SwiftUI

struct CustomAlertAnswerView: View {
    @Binding var isPresented: Bool
    
    let titleKey:        LocalizedStringKey
    let trueCount:  LocalizedStringKey
    let wrongCount:  LocalizedStringKey
    let averageAnswer:  LocalizedStringKey
    let accuracy:  LocalizedStringKey
    let acceptText:      LocalizedStringKey
    let deniedText:      LocalizedStringKey
    
    let acceptFunc: (() -> Void)?
    let deniedFunc: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Arka plan karartması + tıklanınca kapanma
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .contentShape(Rectangle()) // Tıklamayı algılat
                .onTapGesture {
                    isPresented = false
                }

            VStack(spacing: 20) {
                Text(titleKey)
                    .font(.title2).bold()
                    .multilineTextAlignment(.center)
                
                Text(trueCount)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                
                Text(wrongCount)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                
                Text(averageAnswer)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                
                Text(accuracy)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                
                Button {
                    deniedFunc?()
                    isPresented = false
                } label: {
                    Text(deniedText)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                Button {
                    acceptFunc?()
                    isPresented = false
                } label: {
                    Text(acceptText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(28)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
            .padding(.horizontal, 32)
        }
    }
}
extension View {
    func customAnswerAlert(
        isPresented: Binding<Bool>,
        titleKey: LocalizedStringKey,
        trueCount: LocalizedStringKey,
        wrongCount: LocalizedStringKey,
        averageAnswer: LocalizedStringKey,
        accuracy: LocalizedStringKey,
        acceptText: LocalizedStringKey,
        deniedText: LocalizedStringKey,
        acceptFunc: (() -> Void)? = nil,
        deniedFunc: (() -> Void)? = nil
    ) -> some View {
        fullScreenCover(isPresented: isPresented) {
            CustomAlertAnswerView(
                isPresented:  isPresented,
                titleKey:     titleKey,
                trueCount:    trueCount,
                wrongCount:   wrongCount,
                averageAnswer:averageAnswer,
                accuracy:     accuracy,
                acceptText:   acceptText,
                deniedText:   deniedText,
                acceptFunc:   acceptFunc,
                deniedFunc:   deniedFunc
            )
            .presentationBackground(.clear)
        }
    }
}
