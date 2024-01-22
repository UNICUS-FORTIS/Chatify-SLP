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
    
    enum ErrorCodes: String {
        case tokenExpired = "E05" // Access Token Expired
        case e11 = "E11"
        case e12 = "E12"
        
        var description: String {
            switch self {
            case .e11:
                return ToastMessages.Join.invalidEmail.description
            case .e12:
                return ToastMessages.Join.joinedMember.description
            default :
                return ""
            }
        }
    }
    
}
