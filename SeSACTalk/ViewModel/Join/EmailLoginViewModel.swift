//
//  EmailLoginViewModel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/8/24.
//

import Foundation
import RxSwift
import RxCocoa



final class EmailLoginViewModel {
    
    let networkService = NetworkService.shared
    let emailSubject = PublishSubject<String>()
    let passcodeSubject = PublishSubject<String>()
    let deviceToken = BehaviorSubject<String>(value: UserdefaultManager.createDeviceToken() ?? ""    )
    private let center = ValidationCenter()
    
    var isFormValid: Observable<Bool> {
        return Observable.combineLatest(emailSubject,
                                        passcodeSubject)
        .map { email, passcode in
            return self.center.validateEmail(email) && self.center.validatePasscode(passcode)
        }
    }
    
    var isFormInputed: Observable<Bool> {
        return Observable.combineLatest(emailSubject,
                                        passcodeSubject)
        .map { email, passcode in
            if email.count > 0 || passcode.count > 0 {
                return true
            } else {
                return false
            }
        }
    }
    
    var emailLoginRequestForm: Observable<EmailLoginRequest> {
        return Observable.combineLatest(emailSubject,
                                        passcodeSubject,
                                        deviceToken) {
            email, passcode, deviceToken in
            
            return EmailLoginRequest(email: email,
                                     password: passcode,
                                     deviceToken: deviceToken )
        }
    }
}
