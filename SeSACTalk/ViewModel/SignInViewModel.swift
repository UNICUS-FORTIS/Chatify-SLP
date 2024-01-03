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
    
    var isFormValid: Observable<Bool> {
        return Observable
            .combineLatest(emailSubject,
                           nicknameSubject,
                           contactSubject,
                           passcodeSubject,
                           passcodeConfirmSubject
            ) { email,
                nickname,
                contact,
                passcode,
                passcodeConfirm in
                
                let emailValid = self.validateEmail(email)
                let nicknameValid = self.validateNickname(nickname)
                let contact = self.validateContact(contact)
                let passcodeValid = self.validatePasscode(passcode)
                let passcodeConfirmValid = self.confirmPasscode(passcode,
                                                                passcodeConfirm)
                
                
                return emailValid &&
                nicknameValid &&
                contact &&
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
        let nickNameRegex = "^(?=.*[가-힣A-Za-z])[가-힣A-Za-z0-9]+$"
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
        guard !contact.isEmpty else { return false }
        let numericCharacterSet = CharacterSet.decimalDigits
        let inputCharacterSet = CharacterSet(charactersIn: contact)
        return numericCharacterSet.isSuperset(of: inputCharacterSet)
    }
}
