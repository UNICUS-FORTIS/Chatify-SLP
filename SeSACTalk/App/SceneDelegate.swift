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
    private let handler = SocialLoginHandler()
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        guard let method = LoginMethod.activeMethod() else { 
            window = UIWindow(windowScene: windowScene)
            let naviVC = UINavigationController(rootViewController: OnboardingViewController())
            window?.rootViewController = naviVC
            window?.makeKeyAndVisible()
            return
        }
        
        switch method {
        case .apple:
            guard let user = UserdefaultManager.createAppleLoginName() else {
                print("등록된 유저 없음")
            return }
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: user) { credentialState, error in
                switch credentialState {
                case .revoked:
                    print("Revoked")
                
                case .authorized:
                    print("애플로그인 인가 됨")
                    DispatchQueue.main.async {
                        self.window = UIWindow(windowScene: windowScene)
                        let naviVC = UINavigationController(rootViewController: LoginGateViewController(loginMethod: method))
                        self.window?.rootViewController = naviVC
                        self.window?.makeKeyAndVisible()
                        return
                    }
                
                default:
                    print("not Found !@!@!@!@")
                }
            }
            
        case .kakao:
            print("카카오 로그인 시도중")
            handler.fetchKakaoLoginRequest() { [weak self] in
                DispatchQueue.main.async {
                    self?.window = UIWindow(windowScene: windowScene)
                    let naviVC = UINavigationController(rootViewController: LoginGateViewController(loginMethod: method))
                    self?.window?.rootViewController = naviVC
                    self?.window?.makeKeyAndVisible()
                    return
                }
            }
            
            
        case .email:
            return
        }
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

