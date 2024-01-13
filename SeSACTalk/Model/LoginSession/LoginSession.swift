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
    
    private let userIDSubject = PublishSubject<Int>()
    private let nickNameSubject = PublishSubject<String>()
    private let workSpacesSubject = PublishSubject<WorkSpaces>()
    private let disposeBag = DisposeBag()
    
    var userId: Observable<Int> {
        return userIDSubject.asObservable()
    }
    
    func handOverLoginInformation(id: Int,
                                  nick: String,
                                  access: String,
                                  refresh: String) {
        print(access, refresh)
        userIDSubject.onNext(id)
        nickNameSubject.onNext(nick)
        UserDefaults.standard.setValue(access, forKey: "accessToken")
        UserDefaults.standard.setValue(access, forKey: "refreshToken")
    }
    
    func assinWorkSpaces(spaces: WorkSpaces) {
        workSpacesSubject.onNext(spaces)
    }
    

    
}
