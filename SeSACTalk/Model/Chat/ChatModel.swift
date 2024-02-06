//
//  ChatModel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/1/24.
//

import Foundation

struct ChatModel: Decodable {
    let channelID: Int
    let channelName: String
    let chatID: Int
    let content, createdAt: String
    let files: [String]?
    let user: UserModel

    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case channelName
        case chatID = "chat_id"
        case content, createdAt, files, user
    }
}
