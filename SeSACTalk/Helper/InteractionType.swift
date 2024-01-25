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

enum InteractionTypeCancellable: CaseIterable {
    
    case exitFromWorkspace
    case removeWorkspace
   
    var title: String {
        switch self {
        case .exitFromWorkspace:
            return "워크스페이스 나가기"
        case .removeWorkspace:
            return "워크스페이스 삭제"
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
        }
    }
}

enum InteractionConfirmAcceptable: CaseIterable {
   
    case exitFromWorkspace
    
    var title: String {
        switch self {
        case .exitFromWorkspace:
            return "워크스페이스 나가기"

        }
    }
    
    var description: String {
        switch self {
        case .exitFromWorkspace:
            return """
            회원님은 워크스페이스 관리자입니다.
            워크스페이스 관리자를 다른 멤버로 변경한 후 나갈 수 있습니다.
            """
        }
    }
    
    var confirmButton: String {
        return "확인"
    }
}
