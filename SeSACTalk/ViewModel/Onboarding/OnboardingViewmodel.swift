//
//  OnboardingViewmodel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/9/24.
//


import Foundation
import RxSwift
import RxCocoa



final class OnboardingViewModel {
    
    let networkService = NetworkService.shared
    var joinPagePushTrigger: (() -> Void)?
    let kakaoOAuthToken = PublishSubject<String>()
    let deviceToken = UserDefaults.standard.value(forKey: "tempDeviceToken")
    
    var form: Observable<KakaoLoginRequest> {
        guard let device = deviceToken as? String else { return Observable.empty()}
        let deviceToken = Observable.just(device)
        return Observable.combineLatest(kakaoOAuthToken, deviceToken) {
            oAuth, device in
            return KakaoLoginRequest(oauthToken: oAuth, deviceToken: device)
        }
    }
}
