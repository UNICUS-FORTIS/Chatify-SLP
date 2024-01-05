//
//  EmailValidationResponse.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/4/24.
//

import Foundation


struct ErrorResponse: Decodable, Error {
    let errorCode: String
}
