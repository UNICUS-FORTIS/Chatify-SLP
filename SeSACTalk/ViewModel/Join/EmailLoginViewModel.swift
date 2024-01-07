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
    
    let emailSubject = PublishSubject<String>()
    let passcodeSubject = PublishSubject<String>()
    let deviceToken = BehaviorSubject(value: UserDefaults.standard.value(forKey: "tempDeviceToken") as? String)

    var isFormValid: Observable<Bool> {
        return Observable.combineLatest(emailSubject,
                                        passcodeSubject)
        .map { email, passcode in
            return self.validateEmail(email) && self.validatePasscode(passcode)
        }
    }
    
    var isFormInputed: Observable<Bool> {
        return Observable.combineLatest(emailSubject,
                                        passcodeSubject)
        .map { email, passcode in
            if email.count > 0 && passcode.count > 0 {
                return true
            } else {
                return false
            }
        }
    }
    
    var signInRequestForm: Observable<EmailLoginRequest> {
        return Observable.combineLatest(emailSubject,
                                        passcodeSubject,
                                        deviceToken) {
            email, passcode, deviceToken in
            print(EmailLoginRequest(email: email,
                                password: passcode,
                                deviceToken: deviceToken ?? ""))
            return EmailLoginRequest(email: email,
                                 password: passcode,
                                 deviceToken: deviceToken ?? "")
        }
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    func validatePasscode(_ passcode: String) -> Bool {
        let passcodeRegex = "(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+{}:<>?])[A-Za-z\\d!@#$%^&*()_+{}:<>?]{8,}"
        let passcodeTest = NSPredicate(format: "SELF MATCHES %@", passcodeRegex)
        return passcodeTest.evaluate(with: passcode)
    }

}
