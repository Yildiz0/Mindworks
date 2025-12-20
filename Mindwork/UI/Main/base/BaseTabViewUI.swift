//
//  BaseTabViewUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 2.02.2025.
//

import SwiftUI

struct BaseTabViewUI: View {
    
    @EnvironmentObject private var routerMemory: RouterMemory
    @EnvironmentObject private var routerUser: RouterUserInfo
    @EnvironmentObject private var routerFeed: RouterFeed
    @StateObject private var viewModel = BaseTabViewModel()
    @StateObject private var userManager = UserManager()
    @StateObject var tabbarController = TabBarController()
    @State var selectedTab: Tab = .feed
    
    var initialize = NotificationManager.shared
    @State private var isAddGroupPresented = false
    @State private var isAddMemoryPresented = false
    
    var body: some View {
        TabView(selection: $selectedTab, content: {
            NavigationStack(path: $routerFeed.navPath) {
                FeedUI().environmentObject(routerFeed).navigationDestination(for: RouterFeed.Destination.self) { destination in
                    switch destination {
                    case .feedView:
                        FeedUI().environmentObject(routerFeed)
                    case .colorful_words:
                        FindColorUI().onAppear {
                            tabbarController.hideTabbar()
                        }.onDisappear {
                            tabbarController.showTabbar()
                        }
                    case .catch_pair:
                        CatchPairUI().onAppear {
                            tabbarController.hideTabbar()
                        }.onDisappear {
                            tabbarController.showTabbar()
                        }
                    case .firefly_title:
                        FirefliesUI().onAppear {
                            tabbarController.hideTabbar()
                        }.onDisappear {
                            tabbarController.showTabbar()
                        }
                    case .was_it_there:
                        EmptyView()
                    case .which_different:
                        WhichDifferentUI().onAppear {
                            tabbarController.hideTabbar()
                        }.onDisappear {
                            tabbarController.showTabbar()
                        }
                    case .reflex:
                        ReflexUI().onAppear {
                            tabbarController.hideTabbar()
                        }.onDisappear {
                            tabbarController.showTabbar()
                        }
                    case .word_cube:
                        WordCubeUI().onAppear {
                            tabbarController.hideTabbar()
                        }.onDisappear {
                            tabbarController.showTabbar()
                        }
                    }
                }.tabbarVisibility(visibility: tabbarController.isVisible)
            }.tabItem {
                    Label("Games", systemImage: "house")
                }.tag(Tab.feed)
            
            CalendarUI()
                .tabItem {
                    Label("Statistic", systemImage: "chart.bar")
                }.tag(Tab.history)
            /*
            NavigationStack(path: $routerMemory.navPath) {
                CollectionListUI(isAddCollectionPresented: $isAddGroupPresented, selectedTab: $selectedTab).environmentObject(routerMemory).environmentObject(routerUser).navigationDestination(for: RouterMemory.Destination.self) { destination in
                    switch destination {
                    case .collectionList:
                        CollectionListUI(isAddCollectionPresented: $isAddGroupPresented, selectedTab: $selectedTab).onAppear(){
                            isAddGroupPresented = false
                        }.animation(.default, value: tabbarController.isVisible)
                    case .addCollection:
                        CollectionListUI(isAddCollectionPresented: $isAddGroupPresented, selectedTab: $selectedTab).onAppear {
                            isAddGroupPresented = true
                        }
                    case .memoryList(let data):
                        MemoryListUI(collectionData: data, isAddMemoryPresented: $isAddMemoryPresented).onAppear {
                            tabbarController.hideTabbar()
                        }.onDisappear {
                            tabbarController.showTabbar()
                        }
                    case .memoryDetail(let data):
                        MemoryDetailUI(memoryData: data)
                    case .addMemory(let collectionId):
                        AddMemoryUI(isAddMemoryPresented: $isAddMemoryPresented, collectionId: collectionId)
                    }
                }
            }.tabItem {
                Label("Memories", systemImage: "book")
            }.tag(Tab.task).tabbarVisibility(visibility: tabbarController.isVisible)
            */
            NavigationStack(path: $routerUser.navPath) {
                UserListUI(userManager: userManager).environmentObject(routerUser).navigationDestination(for: RouterUserInfo.Destination.self) { destination in
                    switch destination {
                    case .existRelation:
                        ExistRelationUI(userManager: userManager)
                    case .makeRelation:
                        MakeRelationUI(userManager: userManager)
                    case .resetPassword:
                        ResetPasswordUI()
                    case .userInfo:
                        UserInfoUI(userManager: userManager)
                    case .userList:
                        UserListUI(userManager: userManager)
                    }
                }.tabbarVisibility(visibility: tabbarController.isVisible)
            }.tabItem {
                Label("User", systemImage: "person")
            }.tag(Tab.user)
        })
        .onAppear {
            print("BaseTabViewUI appeared. ViewModel: \(viewModel)")
        }
        .navigationBarBackButtonHidden()
        .accentColor(.blue) // Aktif sekme rengi
        .showNewRelation(isPresent: $viewModel.showRelationAlert, onSuccess: {
            viewModel.onSuccessClick()
        }, messageText: viewModel.alertMessage)
        .fullScreenCover(isPresented: $isAddGroupPresented) {
            AddCollectionUI(isAddCollectionPresented: $isAddGroupPresented)
        }
        .fullScreenCover(isPresented: $isAddMemoryPresented) {
            AddMemoryUI(isAddMemoryPresented: $isAddMemoryPresented, collectionId: routerMemory.selectedCollectionId ?? "")
        }
    }
}
enum Tab {
    case feed,history,task,tree,user
}
/*
 #Preview {
     BaseTabViewUI()
 }
 
 */
