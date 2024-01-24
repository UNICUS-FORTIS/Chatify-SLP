//
//  InteractionType.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/24/24.
//

import Foundation

enum InteractionType {
    case confirm
    case cancellable
}


enum InteractionTypeCancellable {
    
    case workspaceExit
    case removeWorkspace
   
    var title: String {
        switch self {
        case .workspaceExit:
            return "워크스페이스 나가기"
        case .removeWorkspace:
            return "워크스페이스 삭제"
        }
    }
    
    var description: String {
        switch self {
        case .workspaceExit:
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
        case .workspaceExit:
            return "나가기"
        case .removeWorkspace:
            return "삭제"
        }
    }
}
