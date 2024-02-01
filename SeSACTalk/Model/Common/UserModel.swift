//
//  UserModel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/1/24.
//

import Foundation


struct UserModel: Decodable {
    let userID: Int
    let email, nickname: String
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage
    }
}
