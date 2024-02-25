//
//  UserdefaultManager.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/26/24.
//

import Foundation

struct UserdefaultManager {
    
    static func createAccessToken() -> String {
        print(#function)
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return "" }
        print("저장된 엑세스토큰", accessToken)
        return accessToken
    }
    
    static func createRefreshToken() -> String {
        print(#function)
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else { return "" }
        return refreshToken
    }
    
    static func saveDeviceToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "DeviceToken")
    }
    
    static func saveNewAccessToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "accessToken")
    }
    
    static func saveNewRefreshToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "refreshToken")
    }
    
    static func saveAppleUsername(name: String) {
        UserDefaults.standard.setValue(name, forKey: "AppleLoginName")
    }
    
    static func saveAppleEmail(email: String) {
        UserDefaults.standard.setValue(email, forKey: "AppleLoginEmail")
    }
    
    static func saveAppleAppleIDToken(token: String) {
        UserDefaults.standard.setValue(token, forKey: "AppleIDToken")
    }
    
    static func createAppleLoginName() -> String? {
        guard let name = UserDefaults.standard.string(forKey: "AppleLoginName") else { return nil }
        print(name, "애플이름")
        return name
    }
    
    static func createAppleEmail() -> String? {
        guard let email = UserDefaults.standard.string(forKey: "AppleLoginEmail") else { return nil }
        return email
    }
    
    static func createAppleIDToken() -> String? {
        guard let token = UserDefaults.standard.string(forKey: "AppleIDToken") else { return nil }
        return token
    }
    
    static func createDeviceToken() -> String? {
        guard let token = UserDefaults.standard.string(forKey: "DeviceToken") else { return nil }
        return token
    }
    
    static func saveAppleUserIdentifier(identifier: String) {
        UserDefaults.standard.set(identifier, forKey: "AppleUser")
    }
    
    static func removeAppleUserIdentifier() {
        UserDefaults.standard.removeObject(forKey: "AppleUser")
    }
    
    static func setLoginMethod(isLogin: Bool, method: LoginMethod) {
        UserDefaults.standard.set(isLogin, forKey: method.description)
    }
    
    static func setLogout() {
        UserDefaults.standard.set(false, forKey: LoginMethod.apple.description)
        UserDefaults.standard.set(false, forKey: LoginMethod.kakao.description)
        UserDefaults.standard.set(false, forKey: LoginMethod.apple.description)
    }
    
    
}
