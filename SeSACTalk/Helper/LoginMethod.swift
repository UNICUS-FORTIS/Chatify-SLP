//
//  LoginMethod.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/25/24.
//

import Foundation


enum LoginMethod {
    
    case apple
    case kakao
    case email
    
    var description: String {
        switch self {
        case .apple:
            return "apple"
        case .kakao:
            return "kakao"
        case .email:
            return "email"
        }
    }
    
}
