//
//  NewWorkSpaceRequest.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/13/24.
//

import Foundation


struct NewWorkSpaceRequest: Encodable {
    
    let name: String
    let description: String?
    let image: Data
    
}
