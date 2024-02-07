//
//  ChatBodyRequest.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/5/24.
//

import Foundation


struct ChatBodyRequest: Encodable {
    
    let content: String?
    let files: [Data]?
    
}
