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
    
}

extension APIService: TargetType {
    
    var baseURL: URL { URL(string: EndPoints.baseURL)! }
    
    var path: String {
        
        switch self {
        case .emailValidation :
            return EndPoints.Paths.emailValidate
        case .join :
            return EndPoints.Paths.join
        }
        
    }
    
    var method: Moya.Method {
        
        switch self {
            
        case .emailValidation, .join: return .post
//        default : return .get
            
        }
    }
    
    var task: Moya.Task {
        
        switch self {
        case .emailValidation(let model):
            return .requestJSONEncodable(model)
        case .join(let model):
            return .requestJSONEncodable(model)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .emailValidation:
            return [
                SecureKeys.Headers.contentsType : SecureKeys.Headers.contentsTypePair,
                SecureKeys.Headers.Headerkey : SecureKeys.APIKey.secretKey
            ]
        case .join:
            return [
                SecureKeys.Headers.contentsType : SecureKeys.Headers.contentsTypePair,
                SecureKeys.Headers.Headerkey : SecureKeys.APIKey.secretKey
            ]
        }
    }
}
