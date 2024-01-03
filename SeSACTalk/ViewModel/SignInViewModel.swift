//
//  SignInViewModel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import Foundation
import RxSwift
import RxCocoa


final class SignInViewModel {
    
    let emailSubject = PublishSubject<String>()
    let nicknameSubject = PublishSubject<String>()
    let contactSubject = PublishSubject<String>()
    let passcodeSubject = PublishSubject<String>()
    let passcodeConfirmSubject = PublishSubject<String>()
    
    var SignInRequestForm: Observable<SignInRequest> {
        return Observable.combineLatest(emailSubject,
                                        nicknameSubject,
                                        contactSubject,
                                        passcodeSubject,
                                        passcodeConfirmSubject) {
            email, nickname, contact, passcode, passcodeConfirm in
            print(SignInRequest(email: email,
                                password: passcode,
                                nickname: nickname,
                                phone: contact,
                                deviceToken: passcodeConfirm))
            return SignInRequest(email: email,
                                 password: passcode,
                                 nickname: nickname,
                                 phone: contact,
                                 deviceToken: passcodeConfirm)
        }
    }
    
}
