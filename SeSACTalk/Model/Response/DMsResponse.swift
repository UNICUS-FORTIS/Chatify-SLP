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
    let user: User

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case roomID = "room_id"
        case createdAt, user
    }
}

struct User: Decodable {
    let userID: Int
    let email, nickname: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}

