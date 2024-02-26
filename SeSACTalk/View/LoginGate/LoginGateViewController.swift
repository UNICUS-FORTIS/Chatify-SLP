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
    private let networkService = NetworkService.shared
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
        gateAction(target: nil)
    }
    
    func gateAction(target: UIViewController?) {
        setInfoByLoginMethod {
            self.transferViewcController(target: target)
        }
    }

    private func setInfoByLoginMethod(completion: @escaping () -> Void) {
        print(#function)
        switch loginMethod {
        case .apple:
            print("애플 로그인 게이트 오픈")
            guard let appleToken = UserdefaultManager.createAppleIDToken(),
                  let deviceToken = UserdefaultManager.createDeviceToken() else { return }
            let name = UserdefaultManager.createAppleLoginName()
            let form = AppleLoginRequest(idToken: appleToken,
                                         nickname: name,
                                         deviceToken: deviceToken)
            handler.fetchAppleLoginRequest(info: form)
                .subscribe(with: self) { owner, result in
                    print(result)
                    switch result {
                    case .success(let response):
                        owner.session.handOverLoginInformation(userID: response.userID,
                                                               nick: response.nickname,
                                                               access: response.token.accessToken,
                                                               refresh: response.token.refreshToken)
                        UserdefaultManager.saveAppleUsername(name: response.nickname)
                        completion()
                    case .failure(let error):
                        print(error.errorCode)
                    }
                }
                .disposed(by: disposeBag)
            
        case .kakao:
            print("카카오 로그인 게이트 오픈")
            completion()
            
        case .email:
            print("이메일 로그인 게이트 오픈")
            completion()
        }
    }
    
    private func transferViewcController(target: UIViewController?) {
        networkService.fetchRequest(endpoint: .loadWorkSpace,
                                    decodeModel: WorkSpaces.self)
        .subscribe(with: self) { owner, result in
            switch result {
            case .success(let response):
                owner.session.workSpacesSubject.onNext(response)
                guard let safeTarget = target else {
                    if response.count > 0 {
                        let vc = DefaultWorkSpaceViewController.shared
                        self.navigationController?.setViewControllers([vc], animated: false)
                    } else {
                        let vc = HomeEmptyViewController()
                        self.navigationController?.setViewControllers([vc], animated: false)
                    }
                    return
                }
                if response.count  > 0 {
                    let vc = DefaultWorkSpaceViewController.shared
                    safeTarget.navigationController?.setViewControllers([vc], animated: false)
                } else {
                    let vc = HomeEmptyViewController()
                    safeTarget.navigationController?.setViewControllers([vc], animated: false)
                }
                
            case .failure(let error):
                print(error.errorCode)
            }
        }
        .disposed(by: disposeBag)
    }
    
    deinit {
        print("로그인게이트 deinit됨")
    }
}
