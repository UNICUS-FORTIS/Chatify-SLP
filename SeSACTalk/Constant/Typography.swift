//
//  Typegraphy.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import UIKit


enum Typography {
    
    static let title1 = UIFont(name: "SFPro-Bold", size: 22)
    static let title2 = UIFont(name: "SFPro-Bold", size: 14)
    static let bodyBold = UIFont(name: "SFPro-Bold", size: 13)
    static let body = UIFont(name: "SFPro-Regular", size: 13)
    static let caption = UIFont(name: "SFPro-Regular", size: 12)
    static let caption2 = UIFont(name: "SFPro-Regular", size: 11)
    
    
    static func createTitle1() -> UIFont {
        guard let font = Self.title1 else { return UIFont.systemFont(ofSize: 22) }
        return font
    }
    
    static func createTitle2() -> UIFont {
        guard let font = Self.title2 else { return UIFont.systemFont(ofSize: 14) }
        return font
    }
    
    static func createBodyBold() -> UIFont {
        guard let font = Self.bodyBold else { return UIFont.systemFont(ofSize: 13) }
        return font
    }
    
    static func createBody() -> UIFont {
        guard let font = Self.body else { return UIFont.systemFont(ofSize: 13) }
        return font
    }
    
    static func createCaption() -> UIFont {
        guard let font = Self.caption else { return UIFont.systemFont(ofSize: 12) }
        return font
    }
    
    static func createCaption2() -> UIFont {
        guard let font = Self.caption2 else { return UIFont.systemFont(ofSize: 11) }
        return font
    }
}
