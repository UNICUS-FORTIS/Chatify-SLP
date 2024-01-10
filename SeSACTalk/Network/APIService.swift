//
//  APIService.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/4/24.
//

import Foundation
import Moya


enum APIService {
    
    case emailValidation(model: EmailValidationRequest)
    case join(model: SignInRequest)
    case emailLogin(model: EmailLoginRequest)
    case kakaoLogin(model: KakaoLoginRequest)
    case appleLogin(model: AppleLoginRequest)
    
}

extension APIService: TargetType {
    
    var baseURL: URL { URL(string: EndPoints.baseURL)! }
    
    var path: String {
        
        switch self {
        case .emailValidation :
            return EndPoints.Paths.emailValidate
        case .join :
            return EndPoints.Paths.join
        case .emailLogin :
            return EndPoints.Paths.emailLogin
        case .kakaoLogin :
            return EndPoints.Paths.kakaoLogin
        case .appleLogin :
            return EndPoints.Paths.appleLogin
        }
        
    }
    
    var method: Moya.Method {
        
        switch self {
        case .emailValidation,
                .join,
                .emailLogin,
                .kakaoLogin,
                .appleLogin : return .post
        }
    }
    
    var task: Moya.Task {
        
        switch self {
        case .emailValidation(let model):
            return .requestJSONEncodable(model)
        case .join(let model):
            return .requestJSONEncodable(model)
        case .emailLogin(model: let model):
            return .requestJSONEncodable(model)
        case .kakaoLogin(model: let model):
            return .requestJSONEncodable(model)
        case .appleLogin(model: let model):
            return .requestJSONEncodable(model)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .emailValidation, .join, .emailLogin , .kakaoLogin, .appleLogin :
            return [
                SecureKeys.Headers.contentsType : SecureKeys.Headers.contentsTypePair,
                SecureKeys.Headers.Headerkey : SecureKeys.APIKey.secretKey
            ]
        }
    }
}
