//
//  LoginGateViewController.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/24/24.
//

import UIKit
import RxSwift

final class LoginGateViewController: UIViewController {
    
    private let session = LoginSession.shared
    private let handler = SocialLoginHandler()
    private var loginMethod: LoginMethod
    private let disposeBag = DisposeBag()
    
    init(loginMethod: LoginMethod) {
        self.loginMethod = loginMethod
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setInfoByLoginMethod(target: nil)
    }
    
//    private func trasferToViewController(target: UIViewController?) {
//        
//        guard let safeTarget = target else {
//            if session.makeWorkspaceListCount() > 0 {
//                let vc = DefaultWorkSpaceViewController.shared
//                target?.navigationController?.setViewControllers([vc], animated: false)
//            } else {
//                let vc = HomeEmptyViewController()
//                target?.navigationController?.setViewControllers([vc], animated: false)
//            }
//            return
//        }
//        if session.makeWorkspaceListCount() > 0 {
//            let vc = DefaultWorkSpaceViewController.shared
//            self.navigationController?.setViewControllers([vc], animated: false)
//        } else {
//            let vc = HomeEmptyViewController()
//            self.navigationController?.setViewControllers([vc], animated: false)
//        }
//    }
    
    func setInfoByLoginMethod(target: UIViewController?) {
        print(#function)
        switch loginMethod {
        case .apple:
            guard let appleToken = SecureKeys.createAppleIDToken(),
                  let deviceToken = SecureKeys.createDeviceToken() else { return }
            let name = SecureKeys.createAppleLoginName()
            let form = AppleLoginRequest(idToken: appleToken,
                                         nickname: name,
                                         deviceToken: deviceToken)
            handler.fetchAppleLoginRequest(info: form)
                .subscribe(with: self) { owner, result in
                    print(result)
                    switch result {
                    case .success(let response):
                        print(response)
                        owner.session.handOverLoginInformation(userID: response.userID,
                                                               nick: response.nickname,
                                                               access: response.token.accessToken,
                                                               refresh: response.token.refreshToken)
                        
                        guard let safeTarget = target else {
                            if owner.session.makeWorkspaceListCount() > 0 {
                                let vc = DefaultWorkSpaceViewController.shared
                                self.navigationController?.setViewControllers([vc], animated: false)
                            } else {
                                let vc = HomeEmptyViewController()
                                self.navigationController?.setViewControllers([vc], animated: false)
                            }
                            return
                        }
                        print("여기실행되니?222")
                        if owner.session.makeWorkspaceListCount() > 0 {
                            let vc = DefaultWorkSpaceViewController.shared
                            safeTarget.navigationController?.setViewControllers([vc], animated: false)
                        } else {
                            let vc = HomeEmptyViewController()
                            safeTarget.navigationController?.setViewControllers([vc], animated: false)
                        }
                        print("실행완료")
                        
                    case .failure(let error):
                        print(error.errorCode)
                    }
                }
                .disposed(by: disposeBag)
        case .kakao:
            break
        case .email:
            break
        }
    }
    
    deinit {
        print("로그인게이트 deinit됨")
    }
}
