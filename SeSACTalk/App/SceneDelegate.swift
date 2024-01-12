//
//  SceneDelegate.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import UIKit
import KakaoSDKAuth
import RxKakaoSDKAuth
import AuthenticationServices


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
//        
//        guard let user = UserDefaults.standard.string(forKey: "AppleUser") else {
//            print("No User")
//            window = UIWindow(windowScene: windowScene)
//            let naviVC = UINavigationController(rootViewController: SignInViewController())
//            window?.rootViewController = naviVC
//            window?.makeKeyAndVisible()
//            return
//        }
//        
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        appleIDProvider.getCredentialState(forUserID: user) { credentialState, error in
//            switch credentialState {
//            case .revoked: print("Revokedㅋㅋㅋ")
//            
//            case .authorized:
//                print("hi")
////                DispatchQueue.main.asyncAndWait {
////                    let window = UIWindow(windowScene: windowScene)
////                    window.rootViewController = MainViewController()
////                    self.window = window
////                    window.makeKeyAndVisible()
////                }
//            
//            default: print("not Found !@!@!@!@")
//            }
//        }
        
        window = UIWindow(windowScene: windowScene)
        let naviVC = UINavigationController(rootViewController: EmptyWorkSpaceEditViewController())
        window?.rootViewController = naviVC
        window?.makeKeyAndVisible()
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

