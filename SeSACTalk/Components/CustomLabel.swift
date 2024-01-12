//
//  CustomLabel.swift
//  SeSACTalk
//
//  Created by LOUIE MAC on 1/3/24.
//

import UIKit


final class CustomLabel: UILabel {
    
    private var attrText: NSAttributedString
    private let normalText: String

    
    override init(frame: CGRect) {
        self.attrText = NSAttributedString(string: "")
        self.normalText = ""
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }
    
    convenience init(_ text: NSAttributedString, font: UIFont) {
        self.init(frame: .zero)
        self.attributedText = text
        self.font = font
        self.textAlignment = .center
    }
    
    convenience init(_ text: String, font: UIFont) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.textAlignment = .left
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
