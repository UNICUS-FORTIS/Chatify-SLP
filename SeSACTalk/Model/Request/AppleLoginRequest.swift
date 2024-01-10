//
//  AppleLoginRequest.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/10/24.
//

import Foundation


struct AppleLoginRequest: Encodable {
    let idToken: String
    let nickname: String
    let deviceToken: String
}
