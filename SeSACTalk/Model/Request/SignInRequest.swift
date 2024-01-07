//
//  SignInForm.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import Foundation


struct SignInRequest: Encodable {
    
    let email: String
    let password: String
    let nickname: String
    let phone: String
    let deviceToken: String

}
