//
//  WorkSpaceInfoResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/14/24.
//

import Foundation


struct ChannelInfoResponse: Decodable {
    let workspaceID: Int
    let description: String?
    let name, thumbnail: String
    let ownerID: Int
    let createdAt: String
    let channels: [Channel]
    let workspaceMembers: [WorkspaceMember]

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name, description, thumbnail
        case ownerID = "owner_id"
        case createdAt, channels, workspaceMembers
    }
}

struct Channel: Decodable {
    let workspaceID, channelID: Int
    let description: String?
    let name: String
    let ownerID, channelPrivate: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case channelID = "channel_id"
        case name, description
        case ownerID = "owner_id"
        case channelPrivate = "private"
        case createdAt
    }
}

struct WorkspaceMember: Decodable {
    let userID: Int
    let email, nickname: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}

typealias WorkspaceResponse = [WorkspaceMember]
