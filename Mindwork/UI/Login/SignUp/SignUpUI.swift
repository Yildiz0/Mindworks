import SwiftUI
import AuthenticationServices

struct SignUpUI: View {
    
    @EnvironmentObject var router: RouterUserSign
    @StateObject var viewModel = SignUpViewModel()
    
    var body: some View {
        ZStack {
            VStack() {
                CustomWaveView(gradient: Gradient(colors: [Color.orange700, Color.red300]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: Height.mediumHeight)
                    .shadow(radius: Radius.shadowRadius)
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)//ekranın çentiklerini vs göz artı edip en yukarı çık
            
            VStack(spacing: Height.smallHeight) {
                Spacer().frame(height: Height.smallHeight)
                
                BigSizeBoldGrad(text: StringKey.create_account)

                VStack(spacing: Height.mediumHeight) {
                    tfIcon(iconSystemName: Icons.envelope, placeHolder: StringKey.email, textInput: $viewModel.email)
                    tfIconSecure(iconSystemName: Icons.lock, placeHolder: StringKey.password, textInput: $viewModel.password)
                    tfIcon(iconSystemName: Icons.person, placeHolder: StringKey.name, textInput: $viewModel.name)
                    tfIcon(iconSystemName: Icons.person, placeHolder: StringKey.surname, textInput: $viewModel.surname)
                    tfIcon(iconSystemName: "person.fill", placeHolder: StringKey.username, textInput: $viewModel.userName)
                }
                
                HStack(spacing: Height.xSmallHeight){
                    Spacer()
                    tvHeadline(text: StringKey.create, color: .blue500)
                    btnSystemIconGradient(iconSystemName: Icons.right_arrow, color: .white) {
                        viewModel.signUpEmail()
                    }
                }
                                
                HStack {
                    tvFootnote(text: StringKey.already_account, color: .primary)
                    btnOnlyText(customView: tvFootnote(text: StringKey.signIn, color: Color.orange700)) {
                        router.navigateBack()
                    }
                }
                
                HStack(spacing: Height.xSmallHeight){
                    btnSignIcon(iconName: Icons.appleIcon) {
                        Task{
                            viewModel.signInWithApple()
                        }
                    }
                    btnSignIcon(iconName: Icons.googleIcon) {
                        Task{
                            viewModel.signInWithGoogle()
                        }
                    }
                    
                }
            }
            .padding(.horizontal, Height.normalHeight)
        }.navigationBarBackButtonHidden()
            .onChange(of: viewModel.success) { success in
                if success {
                    print("✅ Kayıt başarılı! Ana ekrana yönlendiriliyor...")
                }
            }
            .onChange(of: viewModel.error) { error in
                if !error.isEmpty {
                    print("❌ Hata oluştu: \(viewModel.error)")
                }
            }.alert(StringKey.error, isPresented: $viewModel.showAllert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.error)
            }
    }
    
}

#Preview {
    SignUpUI()
}
