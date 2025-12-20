import SwiftUI
import Lottie

struct CustomLottieView: View {
    var animationFileName: String
    var isDotLottieFile: Bool
    let loopMode: LottieLoopMode

    var body: some View {
        LottieView(animation: .named(animationFileName)).playing(loopMode: loopMode)
    }
}

#Preview {
    CustomLottieView(animationFileName: LottieSet.LOADING_CIRCLE_JSON, isDotLottieFile: true, loopMode: LottieLoopMode.loop)
}
