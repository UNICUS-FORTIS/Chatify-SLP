//
//  SocialLoginHandler.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/25/24.
//

import Foundation
import RxSwift


struct SocialLoginHandler {
    
    private let networkService = NetworkService.shared
    
    func fetchKakaoLoginRequest(info: KakaoLoginRequest) -> Single<Result<SignInResponse, ErrorResponse>> {
        return networkService.fetchRequest(endpoint: .kakaoLogin(model: info),
                                           decodeModel: SignInResponse.self)
    }
    
    func fetchAppleLoginRequest(info: AppleLoginRequest) -> Single<Result<SignInResponse, ErrorResponse>> {
        print(#function)
        return networkService.fetchRequest(endpoint: .appleLogin(model: info),
                                           decodeModel: SignInResponse.self)
    }
}
