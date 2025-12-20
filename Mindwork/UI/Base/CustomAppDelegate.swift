//
//  CustomAppDelegate.swift
//  Tendria
//
//  Created by Yakup Kavak on 4.03.2025.
//
import SwiftUI
import FirebaseCore
import FirebaseAppCheck
import FirebaseMessaging
import Foundation

class CustomAppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        application.registerForRemoteNotifications() //for recieve notification
        implementAppCheck()
        implementCloudMessage()
        return true
    }
    func implementCloudMessage(){
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
    }

    func implementAppCheck(){
        UserDefaults.standard.set(true, forKey: "FirebaseAppCheckDebugMode")
        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        FirebaseApp.configure()
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase Registration Token: \(fcmToken ?? "")")
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
          }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
}

extension CustomAppDelegate: UNUserNotificationCenterDelegate {
    // This function lets us do something when the user interacts with a notification
    // like log that they clicked it, or navigate to a specific screen
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
            print("Got notification title: ", response.notification.request.content.title)
        NotificationManager.shared.handleNotification(customData: response.notification.request.content.userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Got notification title: ", notification.request.content.title)
    
        NotificationManager.shared.handleNotification(customData: notification.request.content.userInfo)
    }
    
    /* This function allows us to view notifications in the app even with it in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        // These options are the options that will be used when displaying a notification with the app in the foreground
        // for example, we will be able to display a badge on the app a banner alert will appear and we could play a sound
        return [.badge, .banner, .list, .sound]
    }*/
}
