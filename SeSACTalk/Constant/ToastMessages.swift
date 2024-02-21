//
//  File.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/5/24.
//

import Foundation



enum ToastMessages {
    
    enum Join {
        
        case invalidEmail
        case availiableEmail
        case currntlyValid
        case validationReck
        case invalidNickname
        case invalidPhone
        case invalidPassword
        case invalidPasswordConfirmation
        case joinedMember
        case otherErrors
        
        var description: String {
            
            switch self {
            case .invalidEmail:
                return "이메일 형식이 올바르지 않습니다."
            case .availiableEmail:
                return "사용 가능한 이메일입니다."
            case .currntlyValid:
                return "사용 가능한 이메일입니다."
            case .validationReck:
                return "이메일 중복 확인을 진행해주세요."
            case .invalidNickname:
                return "닉네임은 1글자 이상 30글자 이내로 부탁드려요."
            case .invalidPhone:
                return "잘못된 전화번호 형식입니다."
            case .invalidPassword:
                return "비밀번호는 최소 8자 이상, 하나 이상의 대소문자 / 숫자 / 특수 문자를 설정해주세요."
            case .invalidPasswordConfirmation:
                return "작성하신 비밀번호가 일치하지 않습니다."
            case .joinedMember:
                return "이미 가입된 회원입니다. 로그인을 진행해주세요."
            case .otherErrors:
                return "에러가 발생했어요. 잠시 후 다시 시도해주세요."
            }
        }
    }
    
    enum Channel {
        case editComplted
        
        var description: String {
            
            switch self {
                
            case .editComplted:
                return "채널이 편집되었습니다"
            }
            
        }
    }
}
