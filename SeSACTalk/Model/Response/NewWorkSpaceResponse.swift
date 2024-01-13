//
//  NewWorkSpaceResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/13/24.
//

import Foundation


struct NewWorkSpaceResponse: Decodable {
    
    let workspaceID: Int
    let name: String
    let description: String?
    let thumbnail: String
    let ownerID: Int

    enum CodingKeys: String, CodingKey {
        case workspaceID = "workspace_id"
        case name, description, thumbnail
        case ownerID = "owner_id"
    }
}
