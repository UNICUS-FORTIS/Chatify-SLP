//
//  EmailLoginResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/8/24.
//

import Foundation


struct EmailLoginResponse: Decodable {
    
    let userID: Int
    let nickname, accessToken, refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nickname, accessToken, refreshToken
    }
}
