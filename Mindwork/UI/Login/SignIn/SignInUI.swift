//
//  SignInUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 18.01.2025.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct SignInUI: View {
    
    @EnvironmentObject var router: RouterUserSign
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        ZStack {
            VStack() {
                CustomWaveView(gradient: Gradient(colors: [Color.orange700, Color.red300]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: Height.mediumHeight)
                    .shadow(radius: Radius.shadowRadius)
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)//ekranın çentiklerini vs göz artı edip en yukarı çık
            
            VStack(spacing: Height.normalHeight) {
                Spacer().frame(height: Height.largeHeight)
                
                BigSizeBoldGrad(text: StringKey.welcome)
                
                tvSubHeadline(text: StringKey.signAccount, color: Color.blue500)
                
                VStack(spacing: Height.mediumHeight) {
                    tfIcon(iconSystemName: Icons.envelope, placeHolder: StringKey.email, textInput: $viewModel.email)
                    tfIconSecure(iconSystemName: Icons.lock, placeHolder: StringKey.password, textInput: $viewModel.password)
                }
                
                HStack {
                    Spacer()
                    btnOnlyText(customView: tvFootnote(text: StringKey.forgotPassword, color: Color.red500)) {
                        router.navigate(to: .forgotPassword)
                    }
                }
                
                Spacer()
                
                HStack(spacing: Height.xSmallHeight){
                    Spacer()
                    tvHeadline(text: StringKey.signIn, color: .blue500)
                    btnSystemIconGradient(iconSystemName: Icons.right_arrow, color: .white) {
                        viewModel.signInEmail()
                    }
                }
            
                Spacer()
                Spacer()
                
                HStack {
                    tvFootnote(text: StringKey.dont_account, color: .primary)
                    btnOnlyText(customView: tvFootnote(text: StringKey.create, color: Color.orange700)) {
                        router.navigate(to: .signUp)
                        
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
                Spacer()
            }
            .padding(.horizontal, Height.normalHeight)
        }.navigationBarBackButtonHidden()
            .onChange(of: viewModel.success) { success in
                if success {
                    print("✅ Giriş başarılı! Ana ekrana yönlendiriliyor...")
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
    SignInUI()
        
}
