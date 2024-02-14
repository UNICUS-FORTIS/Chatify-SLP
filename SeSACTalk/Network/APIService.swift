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
    case loadAllChannels(id: IDRequiredRequest)
    //    case joinToChannelChat(id: IDRequiredRequest, name: NameRequest, cursor: ChatCursorDateRequest)
    case joinToChannelChat(id: IDRequiredRequest, name: NameRequest)
    case sendChannelChat(id: IDRequiredRequest, name: NameRequest, contents: ChatBodyRequest)
    case updateProfileImage(image: ImageUpdateRequest)
    case updateProfileInformations(profile: ProfileUpdateRequest)
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
            
        case .loadMyProfile,
                .updateProfileInformations :
            return path.profile
            
        case .refreshToken:
            return path.tokenRefresh
            
        case .editWorkSpace(let id, _),
                .removeWorkSpace(let id):
            return path.workSpace+"/\(id.id)"
            
        case .leaveWorkspace(let id):
            return path.workSpace+"/\(id.id)" +
            path.PathDepthOne.leaveWorkspace
            
        case .handoverWorkspaceManager(let model):
            return path.workSpace +
            "\(model.id)" +
            path.PathDepthOne.handoverWorkspace +
            "\(model.receiverID)"
            
        case .loadWorkspaceMember(let id):
            return path.workSpace +
            "/\(id.id)" +
            path.PathDepthOne.loadWorkspaceMember
            
        case .inviteWorkspaceMember(let id, _):
            return path.workSpace+"/\(id.id)" +
            path.PathDepthOne.loadWorkspaceMember
            
        case .createChannel(let id, _) :
            return path.workSpace+"/\(id.id)" +
            path.PathDepthOne.channel
            
        case .loadMyChannelInfo(let id):
            return path.workSpace+"/\(id.id)" +
            path.PathDepthOne.channel+path.PathDepthTwo.my
            
        case .loadAllChannels(let id):
            return path.workSpace+"/\(id.id)" +
            path.PathDepthOne.channel
            
        case .joinToChannelChat(let id, let name),
                .sendChannelChat(let id, let name, _):
            return path.workSpace+"/\(id.id)" +
            path.PathDepthOne.channel+"/\(name.name)" +
            path.PathDepthTwo.chat
            
        case .updateProfileImage:
            return path.profile+path.PathDepthTwo.updateImage
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
                .createChannel,
                .sendChannelChat :
            return .post
            
        case .loadWorkSpace,
                .loadWorkspaceDetails,
                .loadDms,
                .loadMyProfile,
                .refreshToken,
                .leaveWorkspace,
                .loadWorkspaceMember,
                .loadMyChannelInfo,
                .loadAllChannels,
                .joinToChannelChat:
            return .get
            
        case .editWorkSpace,
                .updateProfileImage,
                .updateProfileInformations:
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
                .loadMyChannelInfo,
                .loadAllChannels,
                .joinToChannelChat:
            return .requestPlain
            
        case .inviteWorkspaceMember(_, let model):
            return .requestJSONEncodable(model)
            
        case .createChannel(_, let model):
            return .requestJSONEncodable(model)
            
            //        case .joinToChannelChat(_, _, let cursor):
            //            return .requestParameters(parameters: ["cursor_date" : cursor],
            //                                      encoding: URLEncoding.queryString)
            
        case .sendChannelChat(_ , _, let body):
            
            var multipartData = [MultipartFormData]()
            
            multipartData.append(MultipartFormData(provider: .data(body.content.data(using: .utf8)!), name: "content"))
            
            if let files = body.files {
                for (index, fileData) in files.enumerated() {
                    multipartData.append(MultipartFormData(provider: .data(fileData),
                                                           name: "files",
                                                           fileName: "SesacTalk\(Date())\(index+1).jpg",
                                                           mimeType: "image/jpeg"))
                }
            }
            
            return .uploadMultipart(multipartData)
            
        case .updateProfileImage(let imageData):
            var multipartFormData = MultipartFormData(provider: .data(imageData.image),
                                                      name: "image", fileName: "profile\(Date()).jpg",
                                                      mimeType: "image/jpeg")
            
            return .uploadMultipart([multipartFormData])
            
        case .updateProfileInformations(let profile):
            return .requestJSONEncodable(profile)
            
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
                .loadMyChannelInfo,
                .loadAllChannels,
                .joinToChannelChat,
                .updateProfileImage,
                .updateProfileInformations :
            
            return [
                SecureKeys.Headers.auth : SecureKeys.Headers.accessToken,
                SecureKeys.Headers.Headerkey : SecureKeys.APIKey.secretKey
            ]
            
        case .sendChannelChat :
            return [
                SecureKeys.Headers.auth : SecureKeys.Headers.accessToken,
                SecureKeys.Headers.contentsType : SecureKeys.Headers.multipartTypePair,
                SecureKeys.Headers.Headerkey : SecureKeys.APIKey.secretKey
            ]
        }
    }
}

