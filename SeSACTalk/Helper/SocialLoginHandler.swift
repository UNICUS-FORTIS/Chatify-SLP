//
//  SocialLoginHandler.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/25/24.
//

import Foundation
import RxSwift
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import AuthenticationServices


final class SocialLoginHandler {
    
    private let networkService = NetworkService.shared
    private let session = LoginSession.shared
    private let disposeBag = DisposeBag()
    
    func fetchKakaoLoginRequest(completion: @escaping () -> Void ) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk()
                .flatMap { token -> Observable<KakaoLoginRequest> in
                    guard let deviceToken = UserdefaultManager.createDeviceToken() else { return Observable.empty() }
                    let form = KakaoLoginRequest(oauthToken: token.accessToken,
                                                 deviceToken: deviceToken)
                    return Observable.just(form)
                }
                .flatMap { request in
                    return self.networkService.fetchRequest(endpoint: .kakaoLogin(model: request),
                                                            decodeModel: SignInResponse.self)
                }.subscribe(with: self) { owner, result in
                    switch result {
                    case .success(let response):
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
        }
    }
    
    func fetchAppleLoginRequest(info: AppleLoginRequest) -> Single<Result<SignInResponse, ErrorResponse>> {
        print(#function)
        return networkService.fetchRequest(endpoint: .appleLogin(model: info),
                                           decodeModel: SignInResponse.self)
    }
    
}
