//
//  ProfileMenuSelector.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/9/24.
//

import Foundation


enum ProfileMenuSelector: CaseIterable {
    
    case accountInfo
    case systemMenu
    
}

enum AccountInformation: CaseIterable {
    case myCoin
    case nickname
    case contact
    
    var title: String {
        switch self {
        case .myCoin:
            return "내 채티 코인"
        case .nickname:
            return "닉네임"
        case .contact:
            return "연락처"
        }
    }
}

enum SystemMenu: CaseIterable {
    case email
    case connectedAccounts
    case logout
    
    var title: String {
        switch self {
        case .email:
            return "이메일"
        case .connectedAccounts:
            return "연결된 소셜 계정"
        case .logout:
            return "로그아웃"
        }
    }
}
