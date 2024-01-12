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
    let deviceToken = UserDefaults.standard.value(forKey: "tempDeviceToken") as? String
    lazy var appleFullName = UserDefaults.standard.string(forKey: "AppleLoginName")
    lazy var appleEmail = UserDefaults.standard.string(forKey: "AppleLoginEmail")
    
    private let disposeBag = DisposeBag()
    
    func fetchAppleLogin(form: AppleLoginRequest) {
        networkService.fetchAppleLoginRequest(info: form)
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let response) :
                    print(response)
                case .failure(let error) :
                    print(error.errorCode)
                }
            }
            .disposed(by: disposeBag)
    }
}
