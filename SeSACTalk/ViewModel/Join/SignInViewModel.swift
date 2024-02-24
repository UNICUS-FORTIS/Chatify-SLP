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
    
    private let networkService = NetworkService.shared
    let session = LoginSession.shared
    let emailSubject = PublishSubject<String>()
    let nicknameSubject = PublishSubject<String>()
    let contactSubject = PublishSubject<String>()
    let passcodeSubject = PublishSubject<String>()
    let passcodeConfirmSubject = PublishSubject<String>()
    let deviceToken = BehaviorSubject(value: UserDefaults.standard.value(forKey: "tempDeviceToken") as? String)
    
    let emailValidationSubject = BehaviorSubject<Bool>(value: false)
    var validatedEmail: String?
    let emailTextfieldisInputed = BehaviorSubject<Bool>(value: false)
    private let validationCenter = ValidationCenter()
    
    func checkEmailStatusCode(code: Int) -> Bool {
        switch code {
        case 200...299: return true
        default: return false
        }
    }
    
    
    var signInRequestForm: Observable<SignInRequest> {
        return Observable.combineLatest(emailSubject,
                                        nicknameSubject,
                                        contactSubject,
                                        passcodeSubject,
                                        deviceToken) {
            email, nickname, contact, passcode, deviceToken in
            print(SignInRequest(email: email,
                                password: passcode,
                                nickname: nickname,
                                phone: contact,
                                deviceToken: deviceToken ?? ""))
            return SignInRequest(email: email,
                                 password: passcode,
                                 nickname: nickname,
                                 phone: contact,
                                 deviceToken: deviceToken ?? "")
        }
    }
    
    var isFormValid: Observable<Bool> {
        return Observable
            .combineLatest(emailSubject,
                           emailValidationSubject,
                           nicknameSubject,
                           contactSubject,
                           passcodeSubject,
                           passcodeConfirmSubject
            )
            .map { email,
                emailValidation,
                nickname,
                contact,
                passcode,
                passcodeConfirm in
                
                let emailValid = self.validationCenter.validateEmail(email)
                let emailValidation = emailValidation
                let nicknameValid = self.validationCenter.validateNickname(nickname)
                let contactValid = self.validationCenter.validateContact(contact)
                let passcodeValid = self.validationCenter.validatePasscode(passcode)
                let passcodeConfirmValid = self.validationCenter.confirmPasscode(passcode, passcodeConfirm)
                
                print(emailValid &&
                      emailValidation &&
                      nicknameValid &&
                      contactValid &&
                      passcodeValid &&
                      passcodeConfirmValid)
                
                return emailValid &&
                emailValidation &&
                nicknameValid &&
                contactValid &&
                passcodeValid &&
                passcodeConfirmValid
            }
    }
    
    
    var isPasscodeEqualityValid: Observable<Bool> {
        return Observable.combineLatest(passcodeSubject, passcodeConfirmSubject)
            .map { passcode, confirmPasscode in
                print(!passcode.isEmpty &&
                      !confirmPasscode.isEmpty &&
                      self.validationCenter.validatePasscode(passcode) &&
                      passcode == confirmPasscode)
                
                return !passcode.isEmpty &&
                !confirmPasscode.isEmpty &&
                self.validationCenter.validatePasscode(passcode) &&
                passcode == confirmPasscode
            }
    }
    
    func fetchEmailValidationRequest(info: EmailValidationRequest) -> Single<Result<Int, ErrorResponse>> {
        return networkService.fetchStatusCodeRequest(endpoint: .emailValidation(model: info))
    }
    
    func fetchJoinRequest(info: SignInRequest) -> Single<Result<SignInResponse, ErrorResponse>> {
        return networkService.fetchRequest(endpoint: .join(model: info),
                                           decodeModel: SignInResponse.self)
    }
}
