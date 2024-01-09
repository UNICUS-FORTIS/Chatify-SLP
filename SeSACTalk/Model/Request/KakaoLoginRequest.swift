//
//  KakaoLoginRequest.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/10/24.
//

import Foundation


struct KakaoLoginRequest: Encodable {
    let oauthToken: String
    let deviceToken: String
}
