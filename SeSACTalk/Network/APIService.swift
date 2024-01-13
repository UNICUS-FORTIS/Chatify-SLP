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
    case createWorkSpace(model: NewWorkSpaceRequest)
    case loadWorkSpace
    
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
        case .createWorkSpace :
            return EndPoints.Paths.createWorkSpace
        case .loadWorkSpace:
            return EndPoints.Paths.loadWorkSpace
        }
        
    }
    
    var method: Moya.Method {
        
        switch self {
        case .emailValidation,
                .join,
                .emailLogin,
                .kakaoLogin,
                .appleLogin,
                .createWorkSpace: return .post
        case .loadWorkSpace : return .get
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
            
        case .createWorkSpace(model: let model):
            
            var multipartData = [MultipartFormData]()
            multipartData.append(MultipartFormData(provider: .data(model.name.data(using: .utf8)!),
                                                   name: "name"))
            multipartData.append(MultipartFormData(provider: .data(model.name.data(using: .utf8)!),
                                                   name: "description"))
            multipartData.append(MultipartFormData(provider: .data(model.image),
                                                   name: "image", fileName: "SesacTalk\(Date()).jpg",
                                                   mimeType: "image/jpeg"))
            
            return .uploadMultipart(multipartData)
            
        case .loadWorkSpace:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .emailValidation, .join, .emailLogin , .kakaoLogin, .appleLogin :
            return [
                SecureKeys.Headers.contentsType : SecureKeys.Headers.contentsTypePair,
                SecureKeys.Headers.Headerkey : SecureKeys.APIKey.secretKey
            ]
            
        case .loadWorkSpace, .createWorkSpace :
            return [
                SecureKeys.Headers.auth : SecureKeys.Headers.accessToken,
                SecureKeys.Headers.Headerkey : SecureKeys.APIKey.secretKey
            ]
        }
    }
}
