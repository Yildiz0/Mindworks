//
//  TaskUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 2.02.2025.
//

import SwiftUI

struct CollectionListUI: View {
    
    @EnvironmentObject var routerTask: RouterMemory
    @EnvironmentObject var routerUser: RouterUserInfo
    @StateObject private var viewModel = CollectionListViewModel()
    @Binding var isAddCollectionPresented: Bool
    @Binding var selectedTab: Tab

    var body: some View {
        ZStack {
            if viewModel.loading{
                CustomLottieView(animationFileName: LottieSet.LOADING_CIRCLE_JSON, isDotLottieFile: false, loopMode: .loop)
            }else if let success = viewModel.success{
                switch success {
                case .exist(let collectionRowList):
                    ScrollView(.vertical,showsIndicators: false){
                        LazyVStack(spacing: Padding.rowPadding) {
                            ForEach(collectionRowList) { collection in
                                Button {
                                    routerTask.navigate(to: .memoryList(collection: collection))
                                } label: {
                                    CollectionRowUI(url: collection.imageUrl, subText: collection.title, shouldCancelOnDisappear: true, isFavorite: false)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal,Padding.rowPadding)

                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            btnAddIcon(iconName: "plus") {
                                isAddCollectionPresented = true
                            }.padding()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    
                case .nonExist:
                    VStack{
                        CustomLottieView(animationFileName: LottieSet.NO_DATA_FOUND_JSON, isDotLottieFile: false, loopMode: .loop).frame(width: Width.screenSeventyWidth)
                        tvBodyline(text: StringKey.noneCollectionTitle, color: .blue500).padding(.bottom)
                        tvFootnote(text: StringKey.noneCollectionText, color: .brown300,textAlignment: .leading).padding(.horizontal,32)
                        Spacer()
                        HStack {
                            Spacer()
                            btnAddIcon(iconName: "plus") {
                                isAddCollectionPresented = true
                            }.padding()
                        }
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                case .noneRelation:
                    VStack{
                        Spacer()
                        CustomLottieView(animationFileName: LottieSet.GIVE_HEART, isDotLottieFile: false, loopMode: .loop).frame(width: Width.screenSeventyWidth, height:Height.xxxLargeHeight)
                        Spacer()
                        tvBodyline(text: StringKey.noneRelationTitle, color: .blue500).padding(.bottom)
                        tvFootnote(text: StringKey.noneRelationText, color: .brown,textAlignment: .leading).padding(.horizontal,Padding.constantLargePadding)
                        Spacer()
                        HStack {
                            Spacer()
                            btnTextGradientSmall(action: {
                                self.selectedTab = .user
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    routerUser.navigate(to: .makeRelation)
                                }
                            }, text: StringKey.create_relation_title)
                            Spacer()
                        }.padding(.bottom,Padding.constantLargePadding)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
            }
        }.onAppear {
            if ((viewModel.success?.hasSameCase(as: .nonExist)) == true){
                viewModel.fetchCollectionList()
            }else if ((viewModel.success?.hasSameCase(as: .noneRelation)) == true){
                viewModel.fetchCollectionList()
            }
        }
    }
}


#Preview {
    @State var isAddGroupPresented = false
    @State var selectedTab = Tab.task
    CollectionListUI(isAddCollectionPresented: $isAddGroupPresented, selectedTab: $selectedTab)
}
