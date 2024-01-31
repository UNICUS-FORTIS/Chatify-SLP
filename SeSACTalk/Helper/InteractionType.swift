//
//  InteractionType.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/24/24.
//

import Foundation

enum InteractionType {
    case confirm(InteractionConfirmAcceptable)
    case cancellable(InteractionTypeCancellable)
}

enum InteractionTypeCancellable {
    
    case exitFromWorkspace
    case removeWorkspace
    case loadChannels(name: String)
    
    var title: String {
        switch self {
        case .exitFromWorkspace:
            return "워크스페이스 나가기"
        case .removeWorkspace:
            return "워크스페이스 삭제"
        case .loadChannels:
            return "채널 참여"
        }
    }
    
    var description: String {
        switch self {
        case .exitFromWorkspace:
            return "정말 이 워크스페이스를 떠나시겠습니까?"
        case .removeWorkspace:
            return """
            정말 이 워크스페이스를 삭제하시겠습니까?
            삭제 시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다.
            """
        case .loadChannels(let name):
            return "[\(name)] 채널에 참여하시겠습니까?"
        }
    }
    
    var leftButton: String {
        return "취소"
    }
    
    var rightButton: String {
        switch self {
        case .exitFromWorkspace:
            return "나가기"
        case .removeWorkspace:
            return "삭제"
        case .loadChannels:
            return "확인"
        }
    }
}

enum InteractionConfirmAcceptable: CaseIterable {
    
    case exitFromWorkspace
    case modifyWorkspaceMember
    
    var title: String {
        switch self {
        case .exitFromWorkspace:
            return "워크스페이스 나가기"
        case .modifyWorkspaceMember:
            return "워크스페이스 관리자 변경 불가"
        }
    }
    
    var description: String {
        switch self {
        case .exitFromWorkspace:
            return """
            회원님은 워크스페이스 관리자입니다.
            워크스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다.
            """
        case .modifyWorkspaceMember:
            return """
            워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다.
            새로운 멤버를 워크스페이스에 초대해보세요.
            """
        }
    }
    
    var confirmButton: String {
        return "확인"
    }
}

