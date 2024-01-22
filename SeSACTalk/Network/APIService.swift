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
    case loadWorkSpaceChannels(channel: IDRequiredRequest)
    case loadDms(id: IDRequiredRequest)
    case loadMyProfile
    case refreshToken(token: AccessTokenRequest)
}

extension APIService: TargetType {
    
    var baseURL: URL { URL(string: EndPoints.baseURL)! }
    
    var path: String {
        
        typealias path = EndPoints.Paths
        
        switch self {
        case .emailValidation :
            return path.emailValidate
        case .join :
            return path.join
        case .emailLogin :
            return path.emailLogin
        case .kakaoLogin :
            return path.kakaoLogin
        case .appleLogin :
            return path.appleLogin
        case .createWorkSpace :
            return path.workSpace
        case .loadWorkSpace:
            return path.workSpace
        case .loadWorkSpaceChannels(let channel):
            return path.workSpace+"/\(channel.id)"
        case .loadDms(let id):
            return path.workSpace+"/\(id.id)"+path.PathDepthOne.dms
        case .loadMyProfile:
            return path.profile
        case .refreshToken:
            return path.tokenRefresh
        }
        
    }
    
    var method: Moya.Method {
        
        switch self {
        case .emailValidation,
                .join,
                .emailLogin,
                .kakaoLogin,
                .appleLogin,
                .createWorkSpace:
            return .post
            
        case .loadWorkSpace,
                .loadWorkSpaceChannels,
                .loadDms,
                .loadMyProfile,
                .refreshToken :
            return .get
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

        case .loadWorkSpaceChannels,
                .loadDms,
                .loadWorkSpace,
                .loadMyProfile,
                .refreshToken:
            return .requestPlain
            
        }
    }
    
    var headers: [String : String]? {
        switch self {
            
        case .emailValidation,
                .join,
                .emailLogin,
                .kakaoLogin,
                .appleLogin :
            
            return [
                SecureKeys.Headers.contentsType : SecureKeys.Headers.contentsTypePair,
                SecureKeys.Headers.Headerkey : SecureKeys.APIKey.secretKey
            ]
            
        case .loadWorkSpace,
                .createWorkSpace,
                .loadWorkSpaceChannels,
                .loadDms,
                .loadMyProfile,
                .refreshToken :
            
            return [
                SecureKeys.Headers.auth : SecureKeys.Headers.accessToken,
                SecureKeys.Headers.Headerkey : SecureKeys.APIKey.secretKey
            ]
            
        }
    }
}

