//
//  SignInResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import Foundation


struct SignInResponse: Decodable {
    let userID: Int
    let email,
        nickname,
        profileImage,
        phone,
        vendor,
        createdAt : String
        let token: Token

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage, phone, vendor, createdAt, token
    }
    
    struct Token: Codable {
        let accessToken, refreshToken: String
    }
}
