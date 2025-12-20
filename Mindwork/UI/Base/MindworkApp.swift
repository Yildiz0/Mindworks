//
//  MindworkApp.swift
//  Mindwork
//
//  Created by Yakup Kavak on 2.08.2025.
//

import SwiftUI

@main
struct MindworkApp: App {
    
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) var delegate
    
    @StateObject private var routerTask = RouterMemory()
    @StateObject private var routerUser = RouterUserInfo()
    @StateObject private var routerFeed = RouterFeed()
    @StateObject private var authManager = AuthManager.shared

    private var userState = false
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            if authManager.isSigned {
                BaseTabViewUI().installToast(position: .bottom).environmentObject(routerTask).environmentObject(routerUser).environmentObject(routerFeed).onAppear {
                    UIApplication.shared.addTapGestureRecognizer()
                }
            } else {
                SignContainerUI().installToast(position: .bottom).onAppear {
                    UIApplication.shared.addTapGestureRecognizer()
                }
            }
        }
    }
}
