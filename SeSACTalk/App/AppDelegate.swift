//
//  AppDelegate.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import UIKit
import KakaoSDKCommon
import RxKakaoSDKCommon


@main
 class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        print(#function)
//        
//        UNUserNotificationCenter.current().delegate = self
//
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(
//          options: authOptions,
//          completionHandler: { _, _ in }
//        )
//
//        application.registerForRemoteNotifications()
//        RxKakaoSDK.initSDK(appKey: SecureKeys.NativeAppKey.KakaoNativeAppKey)

      
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    

}

//extension AppDelegate: UNUserNotificationCenterDelegate {
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//        UserDefaults.standard.setValue(token, forKey: "tempDeviceToken")
//        print("디바이스토큰", token)
//        let value = UserDefaults.standard.value(forKey: "tempDeviceToken")
//        print("유저디폴트", value)
//    }
//    
//}

