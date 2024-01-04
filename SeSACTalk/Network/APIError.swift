//
//  APIError.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/4/24.
//

import Foundation

enum APIError:Int, Error {
    
    case cliendSide = 400
    case serverSIde = 500
    case unknownError
    
}
