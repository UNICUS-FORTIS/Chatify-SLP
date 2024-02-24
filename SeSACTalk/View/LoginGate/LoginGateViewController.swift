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
        setInfoByLoginMethod { [weak self] in
            self?.trasferToViewController()
        }
    }
    
    private func trasferToViewController() {
        
        if session.makeWorkspaceListCount() > 0 {
            let vc = DefaultWorkSpaceViewController.shared
            self.navigationController?.setViewControllers([vc], animated: false)
        } else {
            let vc = HomeEmptyViewController()
            self.navigationController?.setViewControllers([vc], animated: false)
        }
    }
    
    private func setInfoByLoginMethod(completion: @escaping () -> Void) {
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
                        completion()
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
