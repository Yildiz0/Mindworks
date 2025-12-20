//
//  TaskAddUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 5.02.2025.
//

import SwiftUI
import _PhotosUI_SwiftUI
import SwiftyCrop
import Toasts

struct AddMemoryUI: View {
    
    @Binding var isAddMemoryPresented: Bool
    @StateObject var viewModel = AddMemoryViewModel()
    @State private var displayedPhoto: UIImage? = nil
    @State private var displayCrop = false
    @State private var isPhotoPickerPresent = false
    var collectionId: String
    let maxPhotoSelect = 1
    @State private var selectedIndex = 0
    @State private var showFullScreen = false
    @FocusState private var focusedField: MemoryState?
    @StateObject private var keyboardObserver = KeyboardObserver.shared
    @Environment(\.presentToast) var presentToast

    init(isAddMemoryPresented: Binding<Bool>, selectedIndex: Int = 0, collectionId: String) {
        self._isAddMemoryPresented = isAddMemoryPresented
        self.selectedIndex = selectedIndex
        self.collectionId = collectionId
    }
    
    var body: some View {
        
        HStack{
            btnSystemIconTransparent(iconSystemName: Icons.left_direction, color: Color.black) {
                isAddMemoryPresented = false
            }
            tvHeadline(text: StringKey.add_memory, color: Color.blue500)
            Spacer()
        }.padding(.horizontal)
        VStack(){
            ZStack{
                ForEach(viewModel.imageSequence.sorted(by: {$0.index < $1.index})) { imageSeq in
                    buildPhotoPicker(imageSeq: imageSeq)
                }
                .listRowBackground(Color.white)
            }.photosPicker(
                isPresented: $isPhotoPickerPresent,
                selection: $viewModel.selectedPhotos,
                maxSelectionCount: viewModel.maxPhotoSelect,
                matching: .images
            ).frame(maxWidth: .infinity,maxHeight: Height.xxxLargeHeight).padding(.horizontal, Padding.constantNormalPadding)
            
            HStack{
                tvSubTitle(text: StringKey.title)
                Spacer()
            }.padding(.vertical)
            tfText(placeHolder: StringKey.memory_name, textInput: $viewModel.titleInput).focused($focusedField, equals: .title).onSubmit {
                focusedField = .comment
            }
            
            HStack{
                tvSubTitle(text: StringKey.select_date)
                Spacer()
            }.padding(.vertical)
            
            HStack{
                DatePickerView(selectedDate: $viewModel.selectedDate)
                Spacer()
            }
            
            HStack{
                tvSubTitle(text: StringKey.note)
                Spacer()
            }.padding(.vertical)
            teText(placeHolder: StringKey.memory_comment, textInput: $viewModel.commentInput).frame(height: Height.xLargeHeight)
                .focused($focusedField, equals: .comment)
                .simultaneousGesture(
                    TapGesture().onEnded({ _ in
                        focusedField = nil
                    })
                )
            
            btnTextGradientInfinity(shadow: Radius.shadowSmallRadius, action: {
                viewModel.saveMemory(collectionId: collectionId)
            }, text: StringKey.add).frame(width: Width.screenHalfWidth).padding(.top,Padding.leadingMediumPadding)
            
            
        }.keyboardAdaptive(canUpdate: $viewModel.showKeyboard)
            .padding(.horizontal).scrollIndicators(.hidden)
            .showLoading(isPresent: $viewModel.loading)
            .onChange(of: viewModel.selectedPhotos) { value in
                if(!value.isEmpty){
                    viewModel.convertDataToImage(selectedIndex: selectedIndex)
                }
            }
            .onChange(of: keyboardObserver.keyboardIsVisible, perform: { isVisible in
                if(focusedField == .comment){
                    viewModel.setKeyboardVisibility(isVisible: isVisible)
                }
            })
            .onChange(of: viewModel.success, perform: {newValue in
                if(newValue){
                    isAddMemoryPresented = false
                    let toast = ToastValue(message: getLocalizedString(StringKey.memory_added))
                    presentToast(toast)
                }
            })
            .fullScreenCover(isPresented: $showFullScreen, content: {
                FullScreenImageUI(image: viewModel.getImage(selectedIndex: selectedIndex))
            })
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func buildPhotoPicker(imageSeq: ImageSeqUI) -> some View {
        UploadImageSequenceUI(
            uiImage: imageSeq.image,
            maxHeight: Height.uploadHighHeight,
            maxWidth: Width.screenSixtyWidth
        ).onLongPressGesture(perform: {
            self.selectedIndex = imageSeq.index
            self.showFullScreen = true
        })
        .overlay(alignment: .topLeading, content: {
            if(imageSeq.index == 0 && !imageSeq.isEmpty){
                btnSystemIconTransparent(iconSystemName: "xmark.circle.fill", color: .black) {
                    viewModel.removeImage(selectedIndex: imageSeq.index)
                }.offset(x: OffsetValue.deleteImageX, y: OffsetValue.deleteImageY).animation(.easeInOut, value: imageSeq.index)
            }
        })
        .onTapGesture {
            self.selectedIndex = imageSeq.index
            isPhotoPickerPresent = true
            print("photo picker da buna tıklandı -> \(imageSeq.index)")
        }.gesture(
            DragGesture()
                .onChanged({ gesture in
                })
                .onEnded { value in
                    if value.translation.width < Threshold.swipeImageLeft {
                        withAnimation(.easeInOut) {
                            viewModel.rotateLeft()
                        }
                    } else if value.translation.width > Threshold.swipeImageRight {
                        withAnimation(.easeInOut) {
                            viewModel.rotateRight()
                        }
                    }
                }
        )
        .stackPosition(position: imageSeq.index, zeroIndexWidth: Width.screenFourtyWidth)
        .modifier(MemoryPhotoModifier(index: imageSeq.index, isImageSelected: viewModel.isImageSelected))
    }
    
    enum MemoryState: Hashable{
        case title
        case comment
    }
}

#Preview {
    @State var isAddMemoryPresented = true
    AddMemoryUI(isAddMemoryPresented: $isAddMemoryPresented, collectionId: "OfL6uiUqS0eDHRugpej8")
}
