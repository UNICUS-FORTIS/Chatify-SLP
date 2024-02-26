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
    
    var isTrue: Bool {
        return UserDefaults.standard.bool(forKey: self.description)
    }
    
    static func activeMethod() -> LoginMethod? {
        if LoginMethod.apple.isTrue {
            return .apple
            
        } else if LoginMethod.kakao.isTrue {
            return .kakao
            
        } else if LoginMethod.email.isTrue {
            return .email
        }
        
        return nil
    }
    
}
