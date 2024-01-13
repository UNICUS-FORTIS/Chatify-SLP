//
//  LoadWorkSpaceRequest.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/13/24.
//

import Foundation


typealias WorkSpaces = [WorkSpace]

struct WorkSpace: Decodable {
    
    let workspaceID: Int
    let name: String
    let description: String
    let thumbnail: String
    let ownerID: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name, description, thumbnail
        case ownerID = "owner_id"
        case createdAt
    }
}
