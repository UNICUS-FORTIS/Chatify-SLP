//
//  WorkSpaceViewModel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/10/24.
//

import Foundation
import RxSwift
import RxCocoa


final class WorkSpaceViewModel {
    
    
    var storedNickname: String {
        if let nickname = UserDefaults.standard.string(forKey: "AppleLoginName") {
            return nickname
        } else {
            return ""
        }
    }
    
    
    
}
