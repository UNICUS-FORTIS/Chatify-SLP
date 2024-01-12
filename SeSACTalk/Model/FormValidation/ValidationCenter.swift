//
//  ValidationCenter.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/8/24.
//

import Foundation

final class ValidationCenter {
    
    var invalidComponents:[CustomInputView] = []
    
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
    
    func checkInput(_ input: CustomInputView, validationClosure: (String) -> Bool) {
        let text = input.textField.text ?? ""
        let validation = validationClosure(text)
        input.validationBinder.onNext(validation)
        
        if !validation {
            invalidComponents.append(input)
        }
    }
    
    func checkWorkspaceName(_ workspace: String) -> Bool {
        if workspace.count > 30 {
            return false
        } else {
            return true
        }
    }
    
}
