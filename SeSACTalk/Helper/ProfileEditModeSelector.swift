//
//  ProfileEditModeSelector.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/13/24.
//

import Foundation


enum ProfileEditModeSelector {
    
    case nickname
    case contact
    
    var title: String {
        switch self {
        case .nickname:
            return "닉네임"
        case .contact:
            return "연락처"
        }
    }
    
}
