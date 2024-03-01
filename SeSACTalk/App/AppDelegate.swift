//
//  AppDelegate.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import UIKit
import Kingfisher
import KakaoSDKCommon
import RxKakaoSDKCommon
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import iamport_ios

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var modifier = AnyModifier { request in
        var newRequest = request
        newRequest.setValue(SecureKeys.Headers.accessToken,
                            forHTTPHeaderField: SecureKeys.Headers.auth)
        newRequest.setValue(SecureKeys.APIKey.secretKey,
                            forHTTPHeaderField: SecureKeys.Headers.Headerkey)
        return newRequest
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        application.registerForRemoteNotifications()
        RxKakaoSDK.initSDK(appKey: SecureKeys.NativeAppKey.KakaoNativeAppKey)
        KingfisherManager.shared.defaultOptions = [.requestModifier(modifier)]
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        application.registerForRemoteNotifications()
        sleep(2)
        return true
    }

    // MARK: - portone setting
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Iamport.shared.receivedURL(url)
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserdefaultManager.saveDeviceToken(token: token)
        print(token)
    }
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let session = LoginSession.shared
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        print(fcmToken, "FCM 토큰")
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        guard let token = fcmToken else { return }
        UserdefaultManager.saveFCMToken(token: token)
        session.fetchSaveFCMToken(token: token)
    }
}
