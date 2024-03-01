//
//  PurchaseValidationResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 3/1/24.
//

import Foundation

struct PurchaseValidationResponse: Decodable {
    
    let billingID: Int
    let merchantUid: String
    let amount, sesacCoin: Int
    let success: Bool
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case billingID = "billing_id"
        case merchantUid = "merchant_uid"
        case amount, sesacCoin, success, createdAt
    }
}
