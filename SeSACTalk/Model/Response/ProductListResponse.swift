//
//  ProductListResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 3/1/24.
//

import Foundation


struct ProductListResponse: Decodable {
    
    let item, amount: String
    
}

typealias ProductList = [ProductListResponse]
