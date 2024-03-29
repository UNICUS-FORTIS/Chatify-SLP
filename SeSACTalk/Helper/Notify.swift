//
//  Notify.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/29/24.
//

import Foundation


enum Notify {
    
    case InviteMember(InviteMemberErrors)
    case createChannels(CreateChannelErrors)
    
}

enum InviteMemberErrors: String {
    case joinedMember = "E12"
    case notFound = "E03"
    case invalidEmail = "E11"
    case unauthorized = "E14"
    case unknown
    case success
    
    var toastMessage: String {
        switch self {
        case .joinedMember:
            return "이미 워크스페이스에 소속된 팀원이에요. "
        case .notFound:
            return "회원 정보를 찾을 수 없습니다. "
        case .invalidEmail:
            return "올바른 이메일을 입력해주세요. "
        case .unauthorized:
            return "관리자만 워크스페이스에 멤버를 초대 할 수 있습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        case .success:
            return "멤버를 성공적으로 초대했습니다. "
        }
    }
}

enum CreateChannelErrors: String {
    case duplicatedName
    case success
    
    var toastMessage: String {
        switch self {
        case .duplicatedName:
            return "워크스페이스에 이미 있는 채널 이름입니다. 다른 이름을 입력해주세요."
        case .success:
            return "채널이 생성되었습니다."
        }
    }
}

enum CoinErrors: String {
    
    case NonexistentPayment = "E81"
    case invalidPayment = "E82"
    case cancel = "cancel"

    var description: String {
        switch self {
        case .NonexistentPayment:
            return "존재하지 않는 결제건입니다."
            
        case .invalidPayment:
            return "유효하지 않은 결제건입니다. "
            
        case .cancel:
            return "결제를 취소하였습니다."
        }
    }
}
