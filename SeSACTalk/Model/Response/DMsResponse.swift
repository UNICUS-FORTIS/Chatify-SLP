//
//  DMsResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/14/24.
//

import Foundation

typealias DMsResponse = [DMs]

struct DMs: Decodable {
    let workspaceID, roomID: Int
    let createdAt: String
    let user: UserModel

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case roomID = "room_id"
        case createdAt, user
    }
}



