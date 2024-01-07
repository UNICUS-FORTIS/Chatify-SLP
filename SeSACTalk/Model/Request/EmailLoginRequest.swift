//
//  EmailLoginRequest.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/8/24.
//

import Foundation


struct EmailLoginRequest: Encodable {
    
    let email: String
    let password: String
    let deviceToken: String

}
