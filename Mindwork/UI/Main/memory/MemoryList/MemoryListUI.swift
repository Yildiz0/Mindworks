//
//  TaskDetailListUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 5.02.2025.
//

import SwiftUI
import FirebaseCore

struct MemoryListUI: View {
    
    @EnvironmentObject var routerMemory: RouterMemory
    @StateObject private var viewModel: MemoryListViewModel
    var collectionData: CollectionDocumentModel
    @Binding var isAddMemoryPresented: Bool
    
    init(collectionData: CollectionDocumentModel,isAddMemoryPresented: Binding<Bool>) {
        self.collectionData = collectionData
        self._isAddMemoryPresented = isAddMemoryPresented
        self._viewModel = StateObject(wrappedValue: MemoryListViewModel(collectionId: collectionData.id ?? ""))
    }
    
    var body: some View {
        ZStack {
            if viewModel.loading{
                CustomLottieView(animationFileName: LottieSet.LOADING_CIRCLE_JSON, isDotLottieFile: false, loopMode: .loop)
            }else if let success = viewModel.success{
                switch success {
                case .exist(let memoryArray):
                    VStack{
                        RowURLImage(imageUrl: collectionData.imageUrl, shouldCancelOnDisappear: true).overlay(alignment: Alignment.topLeading) {
                            btnSystemIconTransparent(iconSystemName: Icons.left_direction, color: Color.white,font:.system(size: FontValue.bigIconSize, weight: .bold)) {
                                routerMemory.navigateBack()
                            }.padding().shadow(radius: Radius.shadowRadius)
                        }
                        tvHeadlineString(text: collectionData.title, color: .blue500)
                        tvFootnoteString(text: collectionData.description, color: .blue500)
                        Divider()
                        ScrollView(.vertical,showsIndicators: false){
                            LazyVStack(spacing: Padding.rowPadding) {
                                ForEach(memoryArray, id: \.self) { memory in
                                    Button {
                                        routerMemory.navigate(to: .memoryDetail(memory: memory))
                                    } label: {
                                        CollectionRowUI(url: memory.imageUrls[0], subText: memory.title, shouldCancelOnDisappear: true, isFavorite: false)
                                    }
                                    .buttonStyle(PlainButtonStyle()).onAppear(
                                        perform: {print("item gözüktü")}
                                    )
                                }
                            }.padding(.horizontal, Padding.rowPadding)
                            .listStyle(.plain)
                        }
                        Spacer()
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            btnAddIcon(iconName: "plus") {
                                routerMemory.selectedCollectionId = collectionData.id
                                isAddMemoryPresented = true
                            }.padding()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                case .nonExist:
                    VStack{
                        HStack{
                            btnSystemIconTransparent(iconSystemName: Icons.left_direction, color: Color.black) {
                                routerMemory.navigateBack()
                            }
                            Spacer()
                        }.padding(.horizontal)
                        CustomLottieView(animationFileName: LottieSet.NO_DATA_FOUND_JSON, isDotLottieFile: false, loopMode: .loop).frame(width: Width.screenSeventyWidth)
                        tvBodyline(text: StringKey.noneMemoryTitle, color: .blue500).padding(.bottom)
                        tvFootnote(text: StringKey.noneMemoryText, color: .brown300,textAlignment: .leading).padding(.horizontal,Padding.constantLargePadding)
                        Spacer()
                        HStack {
                            Spacer()
                            btnAddIcon(iconName: "plus") {                                routerMemory.selectedCollectionId = collectionData.id
                                isAddMemoryPresented = true
                            }.padding()
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
            }
        }.navigationBarHidden(true)
    }
}

#Preview {
    var data = CollectionDocumentModel(id:"bh46faLR6UN3XeAQmmNn",imageUrl: "https://antalyabalikevi.com.tr/wp-content/uploads/2020/04/antalya-sarapevi.jpg", title: "DenemeTitle", relationId: "z2TthSLdsIQ5WloKXfje", description: "yakup", createDate: Timestamp(date: Date()))
    @State var isPres = false
    MemoryListUI(collectionData: data, isAddMemoryPresented: $isPres)
     
}
