//
//  ProfileMenuSelector.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/9/24.
//

import Foundation


enum ProfileMenuSelector {
    
    case accountInfo(AccountInformation)
    case systemMenu(SystemMenu)
    
}

enum AccountInformation {
    case myCoin
    case nickname
    case contact
    
    var title: String {
        switch self {
        case .myCoin:
            return "내 새싹 코인"
        case .nickname:
            return "닉네임"
        case .contact:
            return "연락처"
        }
    }
}

enum SystemMenu {
    case email
    case connectedAccounts
    case Logout
    
    var title: String {
        switch self {
        case .email:
            return "이메일"
        case .connectedAccounts:
            return "연결된 소셜 계정"
        case .Logout:
            return "로그아웃"
        }
    }
}
