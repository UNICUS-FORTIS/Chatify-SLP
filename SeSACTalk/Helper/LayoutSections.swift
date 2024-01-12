//
//  LayoutSections.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/13/24.
//

import Foundation


enum ChannelLayoutSection: CaseIterable {
    case channel
    case directMessage
    case addNewMember
    
    var title: String {
        switch self {
        case .channel:
            return "채널"
        case .directMessage:
            return "다이렉트 메시지"
        case .addNewMember:
            return ""
        }
    }
    
    var footerTitle: String {
        switch self {
        case .channel:
            return "채널 추가"
        case .directMessage:
            return "새 메시지 시작"
        case .addNewMember:
            return "팀원 추가"
        }
    }
}
