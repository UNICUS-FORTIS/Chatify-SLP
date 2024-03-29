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
    case handoverWorkspaceManager(name: String)
    case loadChannels(name: String)
    case exitFromChannel
    case removeChannel
    case logout
    
    var title: String {
        switch self {
        case .exitFromWorkspace:
            return "워크스페이스 나가기"
        case .removeWorkspace:
            return "워크스페이스 삭제"
        case .handoverWorkspaceManager(let name):
            return "\(name) 님을 관리자로 지정하시겠습니까?"
        case .loadChannels:
            return "채널 참여"
        case .exitFromChannel:
            return "채널에서 나가기"
        case .removeChannel:
            return "채널 삭제"
        case .logout:
            return "로그아웃"
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
            
        case .handoverWorkspaceManager(_):
            return """
            워크스페이스 관리자는 다음과 같은 권한이 있습니다.
            워크스페이스 이름 또는 설명 변경
            워크스페이스 삭제
            워크스페이스 멤버 초대
            """
        case .loadChannels(let name):
            return "[\(name)] 채널에 참여하시겠습니까?"
            
        case .exitFromChannel:
            return "나가기를 하면 채널 목록에서 삭제됩니다."
            
        case .removeChannel:
            return "정말 이 채널을 삭제하시겠습니까? 삭제 시 멤버/채팅 등 채널 내의 모든 정보가 삭제되며 복구할 수 없습니다."
            
        case .logout:
            return "정말 로그아웃 할까요?"
        }
    }
    
    var leftButton: String {
        return "취소"
    }
    
    var rightButton: String {
        switch self {
        case .exitFromWorkspace,
                .exitFromChannel :
            return "나가기"
            
        case .removeWorkspace,
                .removeChannel:
            return "삭제"
            
        case .loadChannels,
                .handoverWorkspaceManager(_):
            return "확인"
            
        case .logout:
            return "로그아웃"
        }
    }
}

enum InteractionConfirmAcceptable: CaseIterable {
    
    case editWorkspace
    case exitFromWorkspace
    case removeWorkspace
    case modifyWorkspaceManager
    case modifyWorkspaceMember
    case modifyChannelManager
    case exitFromChannel
    case findDmTarget
    
    var title: String {
        switch self {
        case .editWorkspace:
            return "워크스페이스 편집"
            
        case .exitFromWorkspace:
            return "워크스페이스 나가기"
            
        case .removeWorkspace:
            return "워크스페이스 삭제"
            
        case .modifyWorkspaceManager:
            return "워크스페이스 관리자 변경"
            
        case .modifyWorkspaceMember:
            return "워크스페이스 관리자 변경 불가"
            
        case .modifyChannelManager:
            return "채널 관리자 변경 불가"
            
        case .exitFromChannel:
            return "채널에서 나가기"
            
        case .findDmTarget:
            return "DM 시작하기"
        }
    }
    
    var description: String {
        switch self {
        case .editWorkspace:
            return "워크스페이스 편집은 관리자만 할 수 있습니다."
            
        case .exitFromWorkspace:
            return """
            회원님은 워크스페이스 관리자입니다.
            워크스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다.
            """
            
        case .removeWorkspace:
            return "워크스페이스 삭제는 관리자만 할 수 있습니다."
            
        case .modifyWorkspaceManager:
            return "워크스페이스 관리자 변경은 관리자만 할 수 있습니다."
            
        case .modifyWorkspaceMember:
            return """
            워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다.
            새로운 멤버를 워크스페이스에 초대해보세요.
            """
            
        case .modifyChannelManager:
            return "채널 멤버가 없어 관리자 변경을 할 수 없습니다. "
            
        case .exitFromChannel:
            return """
            회원님은 채널 관리자입니다.
            채널 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다.
            """
            
        case .findDmTarget:
            return "워크스페이스 멤버가 없습니다."
        }
    }
    
    var confirmButton: String {
        return "확인"
    }
}

