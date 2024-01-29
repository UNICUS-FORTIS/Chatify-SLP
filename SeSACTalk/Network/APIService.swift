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
    case loadWorkspaceDetails(workspaceID: IDRequiredRequest)
    case loadDms(id: IDRequiredRequest)
    case loadMyProfile
    case refreshToken(token: AccessTokenRequest)
    case editWorkSpace(id: IDRequiredRequest, model:NewWorkSpaceRequest)
    case removeWorkSpace(id: IDRequiredRequest)
    case leaveWorkspace(id: IDRequiredRequest)
    case handoverWorkspaceManager(model: IDwithIDRequest)
    case loadWorkspaceMember(id: IDRequiredRequest)
    case inviteWorkspaceMember(id: IDRequiredRequest, model: EmailValidationRequest)
    case createChannel(id: IDRequiredRequest, model: ChannelAddRequest)
    case loadMyChannelInfo(id: IDRequiredRequest)
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
            
        case .loadWorkspaceDetails(let workspaceID):
            return path.workSpace+"/\(workspaceID.id)"
            
        case .loadDms(let id):
            return path.workSpace+"/\(id.id)"+path.PathDepthOne.dms
            
        case .loadMyProfile:
            return path.profile
            
        case .refreshToken:
            return path.tokenRefresh
            
        case .editWorkSpace(let id, _),
                .removeWorkSpace(let id):
            return path.workSpace+"/\(id.id)"
            
        case .leaveWorkspace(let id):
            return path.workSpace+"/\(id.id)"+path.PathDepthOne.leaveWorkspace
            
        case .handoverWorkspaceManager(let model):
            return path.workSpace+"\(model.id)"+path.PathDepthOne.handoverWorkspace+"\(model.receiverID)"
            
        case .loadWorkspaceMember(let id):
            return path.workSpace+"/\(id.id)"+path.PathDepthOne.loadWorkspaceMember
            
        case .inviteWorkspaceMember(let id, _):
            return path.workSpace+"/\(id.id)"+path.PathDepthOne.loadWorkspaceMember
            
        case .createChannel(let id, _) :
            return path.workSpace+"/\(id.id)"+path.PathDepthOne.channel
            
        case .loadMyChannelInfo(let id):
            return path.workSpace+"/\(id.id)"+path.PathDepthOne.channel+path.PathDepthTwo.my
        }
        
    }
    
    var method: Moya.Method {
        
        switch self {
        case .emailValidation,
                .join,
                .emailLogin,
                .kakaoLogin,
                .appleLogin,
                .createWorkSpace,
                .inviteWorkspaceMember,
                .createChannel:
            return .post
            
        case .loadWorkSpace,
                .loadWorkspaceDetails,
                .loadDms,
                .loadMyProfile,
                .refreshToken,
                .leaveWorkspace,
                .loadWorkspaceMember,
                .loadMyChannelInfo:
            return .get
            
        case .editWorkSpace:
            return .put
            
        case .removeWorkSpace,
                .handoverWorkspaceManager:
            return .delete
        }
    }
    
    var task: Moya.Task {
        
        switch self {
        case .emailValidation(let model):
            return .requestJSONEncodable(model)
            
        case .join(let model):
            return .requestJSONEncodable(model)
            
        case .emailLogin(let model):
            return .requestJSONEncodable(model)
            
        case .kakaoLogin(let model):
            return .requestJSONEncodable(model)
            
        case .appleLogin(let model):
            return .requestJSONEncodable(model)
            
        case .createWorkSpace(let model),
                .editWorkSpace(_, let model):
            
            var multipartData = [MultipartFormData]()
            multipartData.append(MultipartFormData(provider: .data(model.name.data(using: .utf8)!),
                                                   name: "name"))
            multipartData.append(MultipartFormData(provider: .data(model.name.data(using: .utf8)!),
                                                   name: "description"))
            multipartData.append(MultipartFormData(provider: .data(model.image),
                                                   name: "image", fileName: "SesacTalk\(Date()).jpg",
                                                   mimeType: "image/jpeg"))
            
            return .uploadMultipart(multipartData)
            
        case .loadWorkspaceDetails,
                .loadDms,
                .loadWorkSpace,
                .loadMyProfile,
                .refreshToken,
                .removeWorkSpace,
                .leaveWorkspace,
                .handoverWorkspaceManager,
                .loadWorkspaceMember,
                .loadMyChannelInfo:
            return .requestPlain
            
        case .inviteWorkspaceMember(_, let model):
            return .requestJSONEncodable(model)
            
        case .createChannel(_, let model):
            return .requestJSONEncodable(model)
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
                .loadWorkspaceDetails,
                .loadDms,
                .loadMyProfile,
                .refreshToken,
                .editWorkSpace,
                .removeWorkSpace,
                .leaveWorkspace,
                .handoverWorkspaceManager,
                .loadWorkspaceMember,
                .inviteWorkspaceMember,
                .createChannel,
                .loadMyChannelInfo:
            
            return [
                SecureKeys.Headers.auth : SecureKeys.Headers.accessToken,
                SecureKeys.Headers.Headerkey : SecureKeys.APIKey.secretKey
            ]
        }
    }
}

