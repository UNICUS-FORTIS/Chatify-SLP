//
//  PurchaseValidationRequest.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 3/1/24.
//

import Foundation


struct PurchaseValidationRequest: Encodable {
    
    let impUid, merchantUid: String

    enum CodingKeys: String, CodingKey {
        case impUid = "imp_uid"
        case merchantUid = "merchant_uid"
    }
}
