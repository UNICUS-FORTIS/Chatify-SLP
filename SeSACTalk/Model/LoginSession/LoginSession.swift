//
//  LoginSession.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/13/24.
//

import Foundation
import RxSwift
import RxCocoa



final class LoginSession {
    
    static let shared = LoginSession()
    
    private let userID = PublishSubject<Int>()
    private let nickName = PublishSubject<String>()
    private let workSpaces = PublishSubject<WorkSpaces>()
    
    
    
    func handOverLoginInformation(id: Int,
                                  nick: String,
                                  access: String,
                                  refresh: String) {
        print(access, refresh)
        userID.onNext(id)
        nickName.onNext(nick)
        UserDefaults.standard.setValue(access, forKey: "accessToken")
        UserDefaults.standard.setValue(access, forKey: "refreshToken")
    }
    
    func assinWorkSpaces(spaces: WorkSpaces) {
        workSpaces.onNext(spaces)
    }
    
}
