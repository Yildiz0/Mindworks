//
//  UserInfoUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 11.02.2025.
//

import SwiftUI
import _PhotosUI_SwiftUI
import Kingfisher
import SwiftyCrop

struct UserInfoUI: View {
    
    @EnvironmentObject var routerUser: RouterUserInfo
    @StateObject private var viewModel = UserInfoViewModel()
    @State private var showPicker = false
    @ObservedObject var userManager: UserManager

    var body: some View {
        VStack(spacing: 16){
            
            Button{
                showPicker.toggle()
            } label: {
                KFImage.profile(urlString: viewModel.user.profileImageUrl, size: 150).overlay(alignment: .bottomTrailing) {
                    btnAddIcon(iconName: "plus",width: 35) {
                        showPicker.toggle()
                    }
                }
            }.photosPicker(isPresented: $showPicker, selection: $viewModel.selectedPhoto,matching: .images)
            
            Spacer()
            tvBodyline(text: StringKey.yourInfo, color: .blue500).frame(maxWidth: .infinity, alignment: .leading).padding(.bottom)
            
            VStack(alignment: .leading){
                tvFootnote(text: StringKey.name, color: .black).padding(.leading)
                tfText(placeHolder: StringKey.name_placeholder, textInput: $viewModel.nameInput)
            }
            VStack(alignment: .leading){
                tvFootnote(text: StringKey.surname, color: .black).padding(.leading)
                tfText(placeHolder: StringKey.surname_placeholder, textInput: $viewModel.surnameInput)
            }
            VStack(alignment: .leading){
                tvFootnote(text: StringKey.mobile, color: .black).padding(.leading)
                tfText(placeHolder: StringKey.mobile_placeholder, keyboard: .phonePad, textInput: $viewModel.mobileInput)
            }
            VStack(alignment: .leading){
                tvFootnote(text: StringKey.email, color: .black).padding(.leading)
                tfText(placeHolder: StringKey.email_placeholder, keyboard: .emailAddress, textInput: $viewModel.emailInput)
            }
            
            btnTextGradientInfinity(action: {
                viewModel.saveProfile()
            }, text: StringKey.update).padding(.top)
            Spacer()
        }.padding()
            .onChange(of: viewModel.selectedPhoto) { _ in
                viewModel.convertDataToImage()
            }
            .navigateBackView(onClick: routerUser.navigateBack)
            .cropImage(displayCrop: $viewModel.displayCrop, beforeCropImage: viewModel.userBeforeCrop, onFinish: { cropImage in viewModel.putCroppedImage(croppedImage:cropImage)}, maskShape: .circle, maskRadius: 200, zoomSensitivity: 10)
            .onAppear {
                viewModel.fetchProfile()
            }
    }
}

#Preview {
    @StateObject var userManager = UserManager()
    UserInfoUI(userManager: userManager)
}
