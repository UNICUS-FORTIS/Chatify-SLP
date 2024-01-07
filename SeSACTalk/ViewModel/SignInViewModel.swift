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
    
    let networkService = NetworkService.shared
    let emailSubject = PublishSubject<String>()
    let nicknameSubject = PublishSubject<String>()
    let contactSubject = PublishSubject<String>()
    let passcodeSubject = PublishSubject<String>()
    let passcodeConfirmSubject = PublishSubject<String>()
    let deviceToken = BehaviorSubject(value: UserDefaults.standard.value(forKey: "tempDeviceToken") as? String)
    
    let emailValidationSubject = BehaviorSubject<Bool>(value: false)
    var validatedEmail: String?
    let emailTextfieldisInputed = BehaviorSubject<Bool>(value: false)
    
    
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
                
                let emailValid = self.validateEmail(email)
                let emailValidation = emailValidation
                let nicknameValid = self.validateNickname(nickname)
                let contactValid = self.validateContact(contact)
                let passcodeValid = self.validatePasscode(passcode)
                let passcodeConfirmValid = self.confirmPasscode(passcode, passcodeConfirm)
                
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
                      self.validatePasscode(passcode) &&
                      passcode == confirmPasscode)
                
                return !passcode.isEmpty &&
                !confirmPasscode.isEmpty &&
                self.validatePasscode(passcode) &&
                passcode == confirmPasscode
            }
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    func validateNickname(_ nickname: String) -> Bool {
        let nickNameRegex = "^(?=.*[가-힣A-Za-z])[가-힣A-Za-z0-9]{1,30}$"
        let nickNameTest = NSPredicate(format:"SELF MATCHES %@", nickNameRegex)
        return nickNameTest.evaluate(with: nickname)
    }
    
    func validatePasscode(_ passcode: String) -> Bool {
        let passcodeRegex = "(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+{}:<>?])[A-Za-z\\d!@#$%^&*()_+{}:<>?]{8,}"
        let passcodeTest = NSPredicate(format: "SELF MATCHES %@", passcodeRegex)
        return passcodeTest.evaluate(with: passcode)
    }
    
    func confirmPasscode(_ passcode: String, _ confirmedPasscode: String) -> Bool {
        guard !passcode.isEmpty else { return false }
        return passcode == confirmedPasscode
    }
    
    func validateContact(_ contact: String) -> Bool {
        let pattern = #"^\d{3}-\d{3,4}-\d{4}$|^\d{10,11}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: contact)
    }
}
