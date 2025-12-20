import SwiftUI

struct ForgotPasswordUI: View {
    
    @EnvironmentObject private var router: RouterUserSign
    @StateObject var viewModel = ForgotPasswordViewModel()
    
    var body: some View {
        ZStack {
            VStack() {
                CustomWaveView(gradient: Gradient(colors: [Color.orange700, Color.red300]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: Height.mediumHeight)
                    .shadow(radius: Radius.shadowRadius)
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
            
            VStack(spacing: Height.mediumHeight) {
                Spacer().frame(height: Height.mediumHeight)
                
                BigSizeBoldGrad(text: StringKey.reset_password)
                
                Spacer().frame(height: Height.smallHeight)
                VStack(spacing: Height.mediumHeight) {
                    tfIcon(iconSystemName: Icons.envelope, placeHolder: StringKey.email, textInput: $viewModel.email)
                }

                Spacer()
                
                HStack(spacing: Height.xSmallHeight){
                    Spacer()
                    tvHeadline(text: StringKey.reset, color: .blue500)
                    btnSystemIconGradient(iconSystemName: Icons.right_arrow, color: .white) {
                        viewModel.forgotPassword()
                    }
                }
                Spacer()
                HStack {
                    tvFootnote(text: StringKey.already_account, color: .primary)
                    btnOnlyText(customView: tvFootnote(text: StringKey.signIn, color: Color.orange700)) {
                        router.navigateBack()
                    }
                }
                Spacer()
            }
            .padding(.horizontal, Height.normalHeight)
        }.navigationBarBackButtonHidden()
            .alert(viewModel.alertType == .success ? getLocalizedString(StringKey.success) : getLocalizedString(StringKey.error), isPresented: $viewModel.showAllert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertType == .success ? viewModel.success : viewModel.error)
            }
    }
}

#Preview {
    ForgotPasswordUI()
}
