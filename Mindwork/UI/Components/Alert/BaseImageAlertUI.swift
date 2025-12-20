//
//  CloudMessageAlert.swift
//  Tendria
//
//  Created by Yakup Kavak on 1.03.2025.
//

import Foundation
import SwiftUI
import Lottie

struct BaseImageAlertUI: View {
        
    var uiImageSource: String = ImageSet.NOTIFICATION
    var title: LocalizedStringKey = StringKey.notification
    var message: LocalizedStringKey = StringKey.notification_subtext
    var onSuccessText: LocalizedStringKey = StringKey.turn_on
    var onDeniedText: LocalizedStringKey = StringKey.skip_for_now
    var onSuccess: () -> Void
    var onDenied: () -> Void
    let opacity = 0.6
    var body: some View {
        ZStack{
            Color.gray.opacity(opacity).ignoresSafeArea()
            VStack(spacing: Spacing.normalSpacing) {
                ImageAsset(uiImageSource: uiImageSource).frame(height: Height.mediumPlusHeight)
                tvHeadline(text: title, color: .blue500)
                tvColorKey(text: message, color: .subTextGray, font: .callout).padding(.horizontal,Padding.constantMinusMediumPadding)
                
                VStack(spacing: Spacing.normalSpacing) {
                    btnTextGradientInfinity(shadow: 0, action: {
                        onSuccess()
                    }, text: onSuccessText)
                    btnTextTransparent(
                        action: {onDenied()},
                        text: onDeniedText)
                }
            }
            .padding(.all, Padding.constantMediumPadding)
            .padding(.horizontal, Padding.horizontalXSmallPadding)
            .background(Color.white)
            .cornerRadius(Radius.mediumRadius)
            .frame(maxWidth: Padding.constantXLargePadding)
        }.ignoresSafeArea()
        .zIndex(.greatestFiniteMagnitude)
    }
}

struct LoadingAlertUI: View {
    var uiLottieSource = LottieSet.LOADING_CIRCLE_JSON
    //var onSuccess: () -> Void
    let opacity = 0.6
    var body: some View {
        ZStack{
            Color.gray.opacity(opacity).ignoresSafeArea()
            LottieView(animation: .named(uiLottieSource)).playing(loopMode: .loop).scaledToFit().padding().padding(.bottom, Padding.constantMinusMediumPadding)
            .padding(.bottom, Padding.constantMediumPadding)
            .background(Color.white)
            .cornerRadius(Radius.mediumRadius)
            .frame(maxWidth: Width.screenHalfWidth)
        }.ignoresSafeArea()
        .zIndex(.greatestFiniteMagnitude)
    }
}

struct BaseLottieAlertUI: View {
        
    var uiLottieSource: String
    var backgroundFirst: String
    var backgroundSecond: String
    var title: LocalizedStringKey
    var message: String
    var onSuccessText: LocalizedStringKey
    var onSuccess: () -> Void
    let opacity = 0.6
    var body: some View {
        ZStack{
            LottieView(animation: .named(backgroundFirst)).playing(loopMode: .loop).animationSpeed(0.4).scaledToFit().offset(y: UIScreen.main.bounds.height * -0.2)
                    .ignoresSafeArea()
            LottieView(animation: .named(backgroundSecond)).playing(loopMode: .loop).scaledToFit().offset(
                            y: UIScreen.main.bounds.height * 0.4)
                    .ignoresSafeArea()
            Color.gray.opacity(opacity).ignoresSafeArea()
            VStack(spacing: Spacing.normalSpacing) {
                LottieView(animation: .named(uiLottieSource)).playing(loopMode: .loop).scaledToFit().padding(Padding.constantMinusLargePadding).padding(.bottom, Padding.constantMinusMediumPadding)
                tvHeadline(text: title, color: .blue500)
                tvColorString(text: message, color: .subTextGray, font: .callout).padding(.horizontal,Padding.constantMinusMediumPadding).padding(Padding.constantXSmallPadding)
                
                VStack(spacing: Spacing.normalSpacing) {
                    btnTextGradientInfinity(shadow: 0, action: {
                        onSuccess()
                    }, text: onSuccessText,paddingValue: CGFloat(Width.buttonConstantMediumWidth))
                }
            }
            .padding(.bottom, Padding.constantMediumPadding)
            .padding(.horizontal, Padding.horizontalNormalPadding)
            .background(Color.white)
            .cornerRadius(Radius.mediumRadius)
            .frame(maxWidth: Padding.constantXLargePadding)
        }.ignoresSafeArea()
        .zIndex(.greatestFiniteMagnitude)
    }
}

#Preview {
    @State var isPres = true
    let name = "Alice"
    let formattedText = String(format: NSLocalizedString("new_relation_subtext", comment: ""), name)

    BaseLottieAlertUI(uiLottieSource: LottieSet.BEAR_CAT_JSON,backgroundFirst: LottieSet.FIREWORK_JSON ,backgroundSecond:LottieSet.CONFETTI_JSON, title: StringKey.new_relation_title, message: formattedText, onSuccessText: StringKey.continue_text) {
        print("lottie")
    }
}
