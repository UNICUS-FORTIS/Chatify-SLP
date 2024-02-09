//
//  ChatBodyRequest.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 2/5/24.
//

import Foundation
import SocketIO


struct ChatBodyRequest: Encodable, SocketData {
    
    let content: String?
    let files: [Data]?
    
}
