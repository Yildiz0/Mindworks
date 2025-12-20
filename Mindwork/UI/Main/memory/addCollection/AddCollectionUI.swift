//
//  AddGroupUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 5.02.2025.
//

import SwiftUI
import PhotosUI
import SwiftyCrop

struct AddCollectionUI: View {
    
    @Binding var isAddCollectionPresented: Bool
    @StateObject var viewModel = AddCollectionViewModel()
    @State private var displayedPhoto: UIImage? = nil
    @State private var displayCrop = false
    
    let maxPhotoSelect = 1
    
    var body: some View {
        VStack{
            HStack{
                btnSystemIconTransparent(iconSystemName: "chevron.left", color: Color.black) {
                    isAddCollectionPresented = false
                }
                tvHeadline(text: StringKey.add_collection, color: Color.blue500)
                Spacer()
            }.padding(.leading,Padding.leadingMediumPadding)
            
            PhotosPicker(
                selection: $viewModel.selectedPhoto,
                matching: .images
            ) {
                UploadImageUI(uiImage: displayedPhoto ?? UIImage(named: Icons.imageUploadIcon) ?? UIImage(), height: Height.xxxLargeHeight, width: Width.screenEightyWidth, unSelectedHeight: Height.xxLargeHeight, isImageSelected: $viewModel.isImageSelected)
                
            }.padding(.top, viewModel.isImageSelected ? 0 : Padding.horizontalNormalPlusPadding).padding(.bottom,viewModel.isImageSelected ? 0 : Padding.horizontalNormalPadding)
            HStack{
                tvSubTitle(text: StringKey.title)
                Spacer()
            }.padding()
            tfText(placeHolder: StringKey.collection_name, textInput: $viewModel.titleInput).padding(.horizontal)
            
            HStack{
                tvSubTitle(text: StringKey.note)
                Spacer()
            }.padding()
            teText(placeHolder: StringKey.collection_comment, textInput: $viewModel.commentInput).frame(height: Height.xLargeHeight).padding(.horizontal).onTapGesture {
                
            }
            
            btnTextGradientInfinity(shadow: Radius.shadowSmallRadius, action: {
                viewModel.saveCollectionImage()
            }, text: StringKey.add).frame(width: Width.screenHalfWidth).padding(.top,Padding.horizontalNormalPlusPadding)
        }
            .onChange(of: viewModel.selectedPhoto) { _ in
                displayCrop.toggle()
                viewModel.convertDataToImage()
            }.fullScreenCover(isPresented: $displayCrop, content: {
                if let selectedPhoto = viewModel.userBeforeCrop{
                    SwiftyCropView(imageToCrop: selectedPhoto, maskShape: .rectangle, configuration: SwiftyCropConfiguration.init(maskRadius:260,zoomSensitivity: 10,texts: SwiftyCropConfiguration.Texts(
                        cancelButton: getLocalizedString(StringKey.cancel),
                        interactionInstructions: getLocalizedString(StringKey.crop_title),
                        saveButton: getLocalizedString(StringKey.save)
                    ))) { croppedImage in
                        guard let croppedImage else {
                            return
                        }
                        viewModel.putCroppedImage(croppedImage: croppedImage)
                        displayCrop = false
                    }
                }else {
                    Text("Fotoğraf yüklenemedi")
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                displayCrop = false
                            }
                        }
                }
            })
            .onReceive(viewModel.$userPhoto) { selectedPhoto in
                Task { @MainActor in
                    displayedPhoto = selectedPhoto
                }
            }.ignoresSafeArea()
        
    }
}

#Preview {
    @State var isAddGroupPresented = true
    AddCollectionUI(isAddCollectionPresented: $isAddGroupPresented)
}
