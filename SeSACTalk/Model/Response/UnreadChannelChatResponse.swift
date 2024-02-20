//
//  UnreadChannelChatResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/20/24.
//

import Foundation


struct UnreadChannelChatResponse: Decodable {
    let channelID: Int
    let name: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case channelID = "channel_id"
        case name, count
    }
}
