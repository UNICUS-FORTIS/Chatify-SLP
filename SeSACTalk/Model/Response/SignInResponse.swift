//
//  SignInResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import Foundation


struct SignInResponse: Decodable {
    let userID: Int
    let email: String
    let nickname: String
    let profileImage: String?
    let phone: String?
    let vendor: String?
    let createdAt: String
    let token: Token
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case email, nickname, profileImage, phone, vendor, createdAt, token
    }
}

struct Token: Decodable {
    let accessToken, refreshToken: String
}
