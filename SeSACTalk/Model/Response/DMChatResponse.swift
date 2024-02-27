//
//  DMChatResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/27/24.
//

import Foundation


struct DMChatResponse: Codable {
    let workspaceID: Int
    let roomID: Int
    let chats: [DMChatModel]
    
    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case roomID = "room_id"
        case chats
    }
}

struct DMChatModel: Codable {
    let dmID: Int
    let roomID: Int
    let content: String?
    let createdAt: String
    let files: [String]?
    let user: UserModel
    
    enum CodingKeys: String, CodingKey {
        case dmID = "dm_id"
        case roomID = "room_id"
        case content, createdAt, files, user
    }
}
