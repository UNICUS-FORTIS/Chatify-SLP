//
//  UnreadDMChatResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/29/24.
//

import Foundation


struct UnreadDMChatResponse: Decodable {
    let roomID, count: Int

    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case count
    }
}
