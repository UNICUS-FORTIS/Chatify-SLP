//
//  MyProfileResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/14/24.
//

import Foundation


struct MyProfileResponse: Codable {
    let userID: Int
    let email, nickname: String
    let profileImage, phone, vendor: String?
    let sesacCoin: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage, phone, vendor, sesacCoin, createdAt
    }
}
